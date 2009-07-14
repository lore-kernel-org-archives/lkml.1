Return-Path: <linux-kernel-owner+w=401wt.eu-S1752954AbZGNCFN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbZGNCFN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 22:05:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752327AbZGNCFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 22:05:12 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45132 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZGNCFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 22:05:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A5BE7B5.7080500@jp.fujitsu.com>
Date: Tue, 14 Jul 2009 11:04:37 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "Ken'ichi Ohmichi" <oomichi@mxs.nes.nec.co.jp>,
       kexec-ml <kexec@lists.infradead.org>,
       lkml <linux-kernel@vger.kernel.org>, Simon Horman <horms@verge.net.au>
Subject: Re: [PATCH-v2] kdump: Enable kdump if 2nd-kernel is loaded.
References: <4A55A4AE.3000206@mxs.nes.nec.co.jp>	<4A56E069.5040907@jp.fujitsu.com> <4A5AB903.6090204@mxs.nes.nec.co.jp> <m14otga4xa.fsf@fess.ebiederm.org>
In-Reply-To: <m14otga4xa.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman wrote:
> The Documentation for sysrq-c certainly needs to be updated.

No doubt about it.

> If I am doing development on a system I like oops's.  All of the
> information and nothing goes down.  I can get at /proc/kcore etc.
> 
> In a setting where I can't be Johnny on the spot and look at
> things a core dump is probably the best I can get.  In that scenario
> panic_on_oops sounds good.
> 
> As I read the current check it reads:
> If we are going to panic and not oops || panic_on_oops
> 	kexec_should_crash = true;
> 
> Which seems a very reasonable implementation of policy.

If I understand it,

a) panic
b) oops
c) SysRq (from keyboard interrupt)
d) echo c > /proc/sysrq-trigger

   a      b      c      d
common, w/o CONFIG_KEXEC:
 panic  oops   panic   oops  :
 panic  panic  panic   panic : w/ panic_on_oops

A) 2.6.30 + CONFIG_KEXEC:
 panic  oops   -       -     : w/o kdump-image
 panic  panic  -       -     : w/o kdump-image w/ panic_on_oops
 kdump  oops   kdump   kdump : w/ kdump-image
 kdump  kdump  kdump   kdump : w/ kdump-image w/ panic_on_oops

B) 2.6.31-rc1 + CONFIG_KEXEC:
 panic  oops   panic   oops  : w/o kdump-image
 panic  panic  panic   panic : w/o kdump-image w/ panic_on_oops
 kdump  oops   kdump   oops  : w/ kdump-image
 kdump  kdump  kdump   kdump : w/ kdump-image w/ panic_on_oops

C) After this patch + CONFIG_KEXEC:
 panic  oops   panic   oops  : w/o kdump-image
 panic  panic  panic   panic : w/o kdump-image w/ panic_on_oops
 kdump  kdump  kdump   kdump : w/ kdump-image
 kdump  kdump  kdump   kdump : w/ kdump-image w/ panic_on_oops

Ohmichi-san pointed "oops on d) with kdump-image" in B) and suggested
it should be "kdump."
And Eric pointed "kdump on b) without panic_on_oops" in C) and requested
it should be "oops."
(Plus, IMHO, "oops on d) without panic_on_oops" should be "panic.") 

... Right?

Then as I mentioned, use panic in sysrq would be one of solutions.
Are there any better fix?


Thanks,
H.Seto

