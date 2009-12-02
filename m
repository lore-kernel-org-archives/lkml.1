Return-Path: <linux-kernel-owner+w=401wt.eu-S1754959AbZLBRY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959AbZLBRY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 12:24:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754830AbZLBRYz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 12:24:55 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49917 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618AbZLBRYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 12:24:54 -0500
Message-ID: <4B16A2A5.2030307@zytor.com>
Date: Wed, 02 Dec 2009 09:23:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Beulich <JBeulich@novell.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       tglx@linutronix.de, mingo@redhat.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: [tip:core/locking] locking, x86: Slightly shorten  __ticket_spin_trylock()
References: <4B0FF9AC0200007800022713@vpn.id2.novell.com> <tip-133ec7a235160dd44cbd4d82fff65a9983331df9@git.kernel.org> <alpine.LFD.2.00.0912020714420.2872@localhost.localdomain> <4B16A2CC020000780002313A@vpn.id2.novell.com> <alpine.LFD.2.00.0912020853240.2872@localhost.localdomain> <alpine.LFD.2.00.0912020857270.2872@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0912020857270.2872@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2009 09:05 AM, Linus Torvalds wrote:
> 
> Btw, even if gcc just treats 'bool' as 'char' (which is the sane thing to 
> do on x86 anyway - I don't see why it should ever do anything else), we 
> actually mess up in the kernel and make that type confusion even worse.
> 

For what it's worth, the gcc ABI for i386-Linux treats _Bool (bool) as
follows:

When in memory, except stack slots:

	sizeof(_Bool) = 1
	0 is false, 1 is true, any other value is *undefined behavior*.

When in registers, or in a stack slot:

	Registers, and stack slots, are always 4 bytes
	0 is false, 1 is true, any other value is *undefined behavior*.
	
All of which is well-defined.  However, it also only applies to values
in memory, or values passed across function boundaries in registers[1]
-- anything else is *by definition outside the scope of the ABI* and
therefore the compiler can legitimately do whatever is appropriate at
any point in time.

As such, I would agree with Linus in that using an u8 is the right thing
to be handed through the inline asm boundary -- if the compiler needs to
extend it, it will, and if it doesn't, there is no penalty.  Similarly,
a bool can be cast to u8 without penalty.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

