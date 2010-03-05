Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab0CEDnd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 22:43:33 -0500
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:59048 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755148Ab0CEDnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 22:43:32 -0500
From: Frans Pop <elendil@planet.nl>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] v3 kconfig: place git SHA1 in .config output if in SCM
Date: Fri, 5 Mar 2010 04:43:27 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, zippel@linux-m68k.org, mingo@elte.hu,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       geert@linux-m68k.org, cloos@jhcloos.com
References: <20100305025435.GA6836@linux.vnet.ibm.com>
In-Reply-To: <20100305025435.GA6836@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003050443.30431.elendil@planet.nl>
X-OriginalArrivalTime: 05 Mar 2010 03:43:31.0480 (UTC) FILETIME=[0651B180:01CABC16]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 March 2010, Paul E. McKenney wrote:
> o	Added the KBUILD_CONFIG_NO_CHECK_DIRTY environment variable,
> 	and modified scripts/setlocalversion to check it, as suggested
> 	by James Cloos.

Just to state the obvious: this will also affect CONFIG_LOCALVERSION_AUTO.

> @@ -450,12 +457,52 @@ int conf_write(const char *name)
>  	if (env && *env)
>  		use_timestamp = 0;
>
> +	strcpy(localversion, "-?-nopath");
> +	path = getenv(SRCTREE);
> +	if (path && *path) {
> +		strcpy(localversion, "-?-pipe()-failed");
> +		if (pipe(pipefd) != 0)
> +			goto nolocalversion;
> +		env = getenv("KBUILD_CONFIG_NO_CHECK_DIRTY");

Is this line actually needed? AFAICT the variable is unused here and should 
pass down through the environment to the setlocalversion script without 
needing any help.

> +		sprintf(cmdline, "%s/scripts/setlocalversion", path);
> +		strcpy(localversion, "-?-fork()-failed");
> +		pid = fork();

Do I read correctly that you're also postfixing error conditions to the 
kernel version? Don't think that's a great idea TBH. Errors should be 
printed to STDERR as they occur, not as pseudo version strings.

Users coming across them in config files would be very unlikely to be able 
to make any sense of them. IMO, if no VCS version can be determined, 
nothing should be printed.

Cheers,
FJP
