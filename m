Return-Path: <linux-kernel-owner+w=401wt.eu-S1754608AbZLBO5m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754608AbZLBO5m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 09:57:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754422AbZLBO5m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 09:57:42 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:54289 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754220AbZLBO5l convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;8:1>);
	Wed, 2 Dec 2009 09:57:41 -0500
Message-Id: <4B168E7702000078000230C5@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Dec 2009 14:57:43 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: <a.p.zijlstra@chello.nl>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       <tglx@linutronix.de>, <torvalds@linux-foundation.org>,
       <mingo@redhat.com>, <npiggin@suse.de>, <linux-kernel@vger.kernel.org>,
       <linux-tip-commits@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten
	 __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com>
 <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org>
 <20091202132937.GA1564@elte.hu>
 <4B168293020000780002308E@vpn.id2.novell.com>
 <20091202142108.GA5815@elte.hu>
In-Reply-To: <20091202142108.GA5815@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 02.12.09 15:21 >>>
792a99a9 <_raw_spin_lock>:
...
>792a99f3:	89 d8                	mov    %ebx,%eax
>792a99f5:	ff 15 d0 6c f2 79    	call   *0x79f26cd0
>792a99fb:	85 c0                	test   %eax,%eax
...
>792a9a2e:	89 f8                	mov    %edi,%eax
>792a9a30:	ff 15 d0 6c f2 79    	call   *0x79f26cd0
>792a9a36:	85 c0                	test   %eax,%eax

Assuming that these are the calls to __raw_spin_trylock, it is clear that
the generated code isn't what we want: It should be test %al, %al in
both cases.

This isn't a compiler bug, though: ____PVOP_CALL() doesn't properly
deal with rettype being bool. Other than all integer types, casting
to bool isn't just a truncation (or extension), but is an actual
conversion. With the compiler seeing that __eax is declared as
unsigned long, it can optimize the whole operation and avoid the
conversion to bool (and hence test the 32-bit register directly).

While I would think these macros should be fixed accordingly (as it
would be quite easy for others to run into the same trap), for the
case at hand I'm not too certain it would be worthwhile as I believe
the goal is to eliminate at least pv-ops spinlocks anyway due to
their overhead on native (and I have a replacement basically
ready, just that for now it only aims at fully virtualized Xen guests).

In any case, please drop the patch until either paravirt.h gets
fixed (I'll try to find time to look into this), or pv-ops spinlocks gets
eliminated. And I'm sorry for not noticing this before submission.

Jan

