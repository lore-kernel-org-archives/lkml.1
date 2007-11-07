Return-Path: <linux-kernel-owner+w=401wt.eu-S1756721AbXKGEOw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721AbXKGEOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 23:14:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754843AbXKGEOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 23:14:45 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:61831 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbXKGEOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 23:14:43 -0500
Message-Id: <200711070411.lA74Bdvn041341@www262.sakura.ne.jp>
Subject: Re: Defense in depth: LSM *modules*, not a static interface
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: casey@schaufler-ca.com
Cc: crispin@crispincowan.com, simon@fire.lp0.eu, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, cliffe@ii.net, oiaohm@gmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Nov 2007 13:11:39 +0900
References: <671729.27434.qm@web36604.mail.mud.yahoo.com>
In-Reply-To: <671729.27434.qm@web36604.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Casey Schaufler wrote:
> Fine grained capabilities are a bonus, and there are lots of
> people who think that it would be really nifty if there were a
> separate capability for each "if" in the kernel. I personally
> don't see need for more than about 20. That is a matter of taste.
> DG/UX ended up with 330 and I say that's too many.

TOMOYO Linux has own (non-POSIX) capability that can support 65536 capabilities
if there *were* a separate capability for each "if" in the kernel.
http://svn.sourceforge.jp/cgi-bin/viewcvs.cgi/trunk/2.1.x/tomoyo-lsm/patches/tomoyo-capability.diff?root=tomoyo&view=markup

The reason I don't use POSIX capability is that the maximum types are limited to
bitwidth of a variable (i.e. currently 32, or are we going to extend it to 64).
This leads to abuse of CAP_SYS_ADMIN capability.
In other words, it makes fine-grained privilege division impossible.

Since security_capable() cannot receive fine-grained values,
TOMOYO can't do fine-grained privilege division.

I wish if capability machanism has mapping layer like:

#define CAP_DIVIDED_FOO1 0
#define CAP_DIVIDED_FOO2 1
#define CAP_DIVIDED_FOO3 2
  ...
#define CAP_DIVIDED_BAR1 100
#define CAP_DIVIDED_BAR2 101
#define CAP_DIVIDED_BAR3 102

const int cap_divided_to_grouped(int cap_divided)
{
	static const int cap_mapping_array[] = {
		/* [divided index value] = POSIX compatible index value (i.e. 0-31) */
		[CAP_DIVIDED_FOO1] = 0,
		[CAP_DIVIDED_FOO2] = 0,
		[CAP_DIVIDED_FOO3] = 0,
		[CAP_DIVIDED_BAR1] = 1,
		[CAP_DIVIDED_BAR2] = 1,
		[CAP_DIVIDED_BAR3] = 1,
	};
	return cap_mapping_array[cap_divided];
}

int capable(int cap_divided)
{
	return security_capable(cap_divided);
}

int security_capable(int cap_divided)
{
	/* Allow LSM to decide based on fine-grained capability index. */
	return LSM_implementation_specific_capability_check(cap_divided_to_grouped(cap_divided));
}

int function_foo(void)
{
	if (!capable(CAP_DIVIDED_FOO1))
		return -EPERM;
	return 0;
}

int function_bar(void)
{
	if (!capable(CAP_DIVIDED_BAR2))
		return -EPERM;
	return 0;
}

Thanks.
