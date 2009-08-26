Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbZHZM14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbZHZM14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 08:27:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932697AbZHZM14
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 08:27:56 -0400
Received: from mtagate7.de.ibm.com ([195.212.17.167]:32798 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932624AbZHZM1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 08:27:55 -0400
Message-ID: <4A952A25.40208@linux.vnet.ibm.com>
Date: Wed, 26 Aug 2009 14:27:17 +0200
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: michal.simek@petalogix.com
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       "subrata@linux.vnet.ibm.com" <subrata@linux.vnet.ibm.com>
Subject: Re: Gcov and lcov
References: <4A940A11.2040706@petalogix.com>
In-Reply-To: <4A940A11.2040706@petalogix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Michal Simek wrote:
> First of all there should be DEBUG_FS instead of DEBUG in documentation.
> diff --git a/Documentation/gcov.txt b/Documentation/gcov.txt
> index 40ec633..e7ca647 100644
> --- a/Documentation/gcov.txt
> +++ b/Documentation/gcov.txt
> @@ -47,7 +47,7 @@ Possible uses:
> 
>  Configure the kernel with:
> 
> -        CONFIG_DEBUGFS=y
> +        CONFIG_DEBUG_FS=y
>          CONFIG_GCOV_KERNEL=y

Thanks for pointing this out. This was reported before and will be fixed 
in a future kernel release.

> I am missing any option to be possible to stop capture coveradge data.

There is currently no way to turn gcov-based profiling off during run-time.

> I am running in on Microblaze and it takes me a lot of time to grap all
> gcda data from debugfs.

If you don't need coverage data for all of the kernel source, you can 
turn off option CONFIG_GCOV_PROFILE_ALL and only enable profiling for 
those directories or files which are of interest to you. This should 
greatly reduce the number of files that you need to copy and also the 
overall kernel-slowdown.

See the help text for configuration option CONFIG_GCOV_KERNEL for a 
description of how to turn profiling on for single directories or files.

> Then I would like to use lcov and generate html sites. This could be
> possible but I haven't found
> a way how to do it.
> 
> I used lcov --capture --directory . --output-file out
> 
> There is this mishmash in version string
> /home/projects/xils/_full/software/linux-monstr_eu-commit/kernel/spinlock.gcno:version
> '401*', prefer '401p'
> /home/projects/xils/_full/software/linux-monstr_eu-commit/kernel/spinlock.gcda:version
> '401*', prefer version '401p'
> 
> and then genhtml out which end with fault because my out file contain
> wrong patches where is part of path repeated.
> arch/microblaze/kernel/arch/microblaze/kernel

The warning messages you are seeing indicate that the version of gcov 
used for analyzing and the version of gcc used for compiling differ. You 
need to specify the correct gcov tool binary (the one that comes with 
the compiler used to compile the kernel) by using lcov's --gcov-tool option.

Also current lcov releases only contain support for the gcov-kernel 
infrastructure as provided by the external gcov-kernel patch. I added 
support for the new upstream infrastructure to the CVS version[*] of lcov.

Using the CVS version, you can do the following:

On the test machine:
	lcov -c --to-package coveragedata

This will create a file coveragedata which includes all .gcda files. 
Copy this file to the build machine and do:
	lcov -c --from-package coveragedata -o data.info

This will allow you to do the actual analysis of coverage data on the 
build machine. See the man page for lcov for a detailed description of 
this approach.


Regards,
   Peter Oberparleiter

[*] See http://ltp.sourceforge.net/coverage/lcov.php for instructions on 
how to obtain the CVS version of lcov

