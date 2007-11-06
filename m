Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbXKFDqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbXKFDqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 22:46:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754258AbXKFDqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 22:46:08 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:56325 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751938AbXKFDqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 22:46:06 -0500
Message-ID: <472FE383.70103@crispincowan.com>
Date: Mon, 05 Nov 2007 19:46:11 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Cliffe <cliffe@ii.net>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org
Subject: Re: Defense in depth: LSM *modules*, not a static interface
References: <10965.80.126.27.205.1193684677.squirrel@webmail.xs4all.nl>    <4726377A.4080807@crispincowan.com>    <e7d8f83e0710292213h4cf9cddw6e373d60fbab41f9@mail.gmail.com>    <4726D9D9.2000909@ii.net> <29685.simon.1193747418@5ec7c279.invalid>
In-Reply-To: <29685.simon.1193747418@5ec7c279.invalid>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> On Tue, October 30, 2007 07:14, Cliffe wrote:
>   
>> And while I acknowledge that many of these layers are currently buried
>> within the kernel (netfilter...) they are security layers which in many
>> cases would probably make sense as stackable security modules.
>>
>> Making the interface static forces mammoth solutions which then must
>> attempt to solve all of the above in one ls*m*. What happened to
>> dividing tasks into easy to manage chunks?
>>     
> Would it be possible to have Kconfig select which LSM should handle each
> area of security? Selecting LSM A would automatically disable LSM B and
> C since they both implement the same security functions, while LSM D
> would still be selectable since it implements something else. The default
> capabilities code would then turn off parts of itself that another LSM
> is handling.
>   
I get what you mean, but the problem is that there is little consensus
on what "area" means. Rather the opposite, it could easily be the case
that different modules have such a different view of the world that you
cannot easily mechanically determine whether they can stack.

Some categories that occur to me:

    * Restrictive vs. Permissive:
          o LSM is mostly restrictive, but the POSIX.1e Capabilities
            hooks are permissive.
          o Some modules like MultiADM and File Capabilities are
            deliberately permissive, while others like AppArmor and
            SMACK are purely restrictive.
          o In any kind of stacking scheme, it would be important to
            load the permissive modules first, followed by the
            restrictive modules.
          o This becomes problematic as soon as you have a module that
            is both permissive and restrictive.
          o Note: AppArmor is both permissive and restrictive because it
            incorporates the Capabilities code rather than trying to
            stack with it. With a good clean stacker, AA might be able
            to become purely restrictive.
    * Access control vs. Intrusion prevention:
          o An Access control policy is one that specifies what a
            confined subject can access.
          o An Intrusion prevention engine specifies classes of things
            that may never happen, e.g. the Openwall hard and symbolic
            link restrictions.
          o An intrusion prevention mechanism might be a blanket effect
            that prevents the Bad Thing from happening for all
            processes, or it might be policy driven, and only prevent
            the Bad Thing for explicitly confined processes, or
            explicitly allow the Bad Thing for permitted processes.
          o Access control and Intrusion Prevention modules are
            naturally complementary, making stacking very attractive.
          o Note: SELinux already incorporates some intrusion prevention
            features, and AppArmor plans to incorporate such features.
            With a good clean stacker, AA might be able to instead use
            stacking.


> Alternatively the M in LSM can be restored and modules can be stacked.
> It should be possible for the primary LSM to check the security_ops of the
> secondary LSM(s) and complain if it considers there to be an incompatiblity.
>   
That is what I advocate. Restore the modular feature immediately, this
static interface is lots of cost (mostly opportunity cost) and very
little benefit (mostly defense against contrived FUD threats).

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

