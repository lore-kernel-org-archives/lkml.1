Return-Path: <linux-kernel-owner+w=401wt.eu-S1758799AbYFQOnh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799AbYFQOnh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:43:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757794AbYFQOn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:43:28 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:28903 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569AbYFQOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Va7mH+/cnr6+fMeKfO8TgEltjFD6Xhq6ZQu2F3dJ2SCqUU4u0k7hPDNv2eek0DqAGB
         bJmjZ31UJDJPtuQAELgyQsSOeegek3nJm+MXK2ZhAibJuSOHX22454OoBxhJQ41Jbop3
         ppHCYzd5Mp3cr6umlJTw8LBT6OsJPlRn/rccI=
Message-ID: <19f34abd0806170743v274b23a7m85340bccfe9eaf36@mail.gmail.com>
Date: Tue, 17 Jun 2008 16:43:25 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Mathieu Desnoyers" <compudj@krystal.dyndns.org>
Subject: Re: [PATCH 2/3] Better interface for hooking early initcalls.
Cc: "Eduard - Gabriel Munteanu" <eduard.munteanu@linux360.ro>,
       tzanussi@gmail.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
In-Reply-To: <20080617140742.GD10316@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080615180508.71d1cbcc@linux360.ro>
	 <20080617140742.GD10316@Krystal>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2008 at 4:07 PM, Mathieu Desnoyers
<compudj@krystal.dyndns.org> wrote:
> * Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
>> Added early initcall (pre-SMP) support, using an identical interface to
>> that of regular initcalls. Functions called from do_pre_smp_initcalls()
>> could be converted to use this cleaner interface.
>>
>> This is required by CPU hotplug, because early users have to register
>> notifiers before going SMP. One such CPU hotplug user is the relay
>> interface with buffer-only channels, which needs to register such a
>> notifier, to be usable in early code. This in turn is used by kmemtrace.
>>
>
> I am not sure it's worth it trying to define a generic "early" initcall,
> since definition of "how early it is" may change with time.
>
> Currently, it's earlier than SMP init, but later on, it could become
> earlier than mm init. If there are only few users of this, and given
> that they must be designed "knowing" how early they are initialized wrt
> other subsystems, I think it would make sense to call them directly from
> the init code without putting them in a "early initcall" category.

If this existed already, I'd use it for kmemcheck. We need to hook
into what happens just before SMP is initialized in order to set
maxcpus = 1 depending on some kernel parameter. Right now it's called
directly from do_pre_smp_initcalls():

@@ -779,6 +780,7 @@ static void __init do_pre_smp_initcalls(void)
 {
        extern int spawn_ksoftirqd(void);

+       kmemcheck_init();
        migration_init();
        spawn_ksoftirqd();
        if (!nosoftlockup)

With proposed patch, we wouldn't have to touch this file at all, so
for what it's worth, consider it acked by me.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
