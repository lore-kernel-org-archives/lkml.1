Return-Path: <linux-kernel-owner+w=401wt.eu-S1762561AbYHFImF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762561AbYHFImF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 04:42:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762612AbYHFIlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 04:41:25 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:48804 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754519AbYHFIlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 04:41:22 -0400
Date: Wed, 6 Aug 2008 14:10:14 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: jmerkey@wolfmountaingroup.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.27-rc1-git5 2/26] mdb: correct kprobes int3 trap
Message-ID: <20080806084014.GA3777@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <200808050626.m756QZ1g003755@wolfmountaingroup.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200808050626.m756QZ1g003755@wolfmountaingroup.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 05, 2008 at 12:26:35AM -0600, jmerkey@wolfmountaingroup.com wrote:
...

> @@ -850,6 +871,10 @@
>  #ifdef CONFIG_KPROBES
>  void __kprobes do_int3(struct pt_regs *regs, long error_code)
>  {
> +#ifdef	CONFIG_MDB
> +        if (mdb(BREAKPOINT_EXCEPTION, error_code, regs))
> +           return;
> +#endif // CONFIG_MDB
>  	trace_hardirqs_fixup();
> 
>  	if (notify_die(DIE_INT3, "int3", regs, error_code, 3, SIGTRAP)

Kprobes needs to be the first consumer of these exceptions (via
notify_die); if the exception was due to a kprobe, it does its thing
without requiring any user intervention. Here, for example, you can get
into mdb for a kprobe breakpoint hit.

Please move the mdb hooks to after kprobes has been notified. Better
still, integrate mdb to use the notify_die infrastructure and use a
lower priority than what kprobes does for it.

Ananth
