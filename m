Return-Path: <linux-kernel-owner+w=401wt.eu-S933648AbYA2SOo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933648AbYA2SOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 13:14:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759148AbYA2SNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 13:13:13 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:48975 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933788AbYA2SNE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 13:13:04 -0500
Date: Tue, 29 Jan 2008 19:13:06 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sections mismatches: How to mark new false positives?
Message-ID: <20080129181305.GB14056@uranus.ravnborg.org>
References: <20080129170255.GP8767@does.not.exist>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080129170255.GP8767@does.not.exist>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 29, 2008 at 07:02:55PM +0200, Adrian Bunk wrote:
> I'm getting the following in the latest -git:
> 
> <--  snip  -->
> 
> ...
> WARNING: arch/x86/kernel/built-in.o(.exit.text+0x1db): Section mismatch in reference from the function msr_exit() to the variable .cpuinit.data:msr_class_cpu_notifier
> ...
> 
> <--  snip  -->
> 
> That's obviously a false positive (unregister_hotcpu_notifier() is a 
> noop if CONFIG_HOTPLUG_CPU=n), but how can I silence the warning?

What is the purpose of __cpuinit?
It seems to be used for two purposes:

To annotate code that is used to initialize cpu's
  if CONFIG_HOTPLUG_CPU=n then discard it after
                               init has completed
  if CONFIG_HOTPLUG_CPU=y then keep it

To annotate all 'core' cpu hotplug related code
  if CONFIG_HOTPLUG_CPU=n then it is not used and
                               can safely be discarded
  if CONFIG_HOTPLUG_CPU=y then keep it

And the variable msr_class_cpu_notifier belongs to the last category.
So the root cause of all the __cpu* related section mismatch
warnings are the misuse of __cpuinit to mark all core functions.

How are we going to fix this?

I see a couple of possibilities:

1) annotate like hell to hide the misuse of __cpuinit
2) introduce __cpu to make cpu hotplug 'core' stuff
3) drop section mismatch checks for __cpu stuff


	Sam
