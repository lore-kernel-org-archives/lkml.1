Return-Path: <linux-kernel-owner+w=401wt.eu-S1757254AbYGOVmw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254AbYGOVmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 17:42:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbYGOVmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 17:42:44 -0400
Received: from mx1.redhat.com ([66.187.233.31]:37488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbYGOVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 17:42:44 -0400
Date: Tue, 15 Jul 2008 17:29:27 -0400
From: Jason Baron <jbaron@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: [PATCH 0/7] dynamic debug v2
Message-ID: <20080715212927.GA23331@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I've updated the userspace interface and updated the implementation. I'm going
to summarize what has changed below, but for more background, please see:
http://marc.info/?l=linux-kernel&m=121338359012058&w=2


INTERFACE - userspace

The file <debugfs>/dynamic_printk/modules is now formatted as:

<module_name> <enabled=0/1> <level=[0-n]> <flag_name=0/1>....
	<associated module names>
		.
		.
		.


	<module_name> : Name of the module in which the debug call resides
	<enabled=0/1> : whether the the messages are enabled or not
        <level=[0-n]> : For modules that support levels
        <flag_name=0/1> : names of the flags that can be set
        <associated module names> : names of the modules that are part of
                group <module_name>

        Excerpt from my system:

                snd_hda_intel enabled=0

                fixup enabled=0

                cpufreq_shared enabled=0 CPUFREQ_DEBUG_CORE=0 CPUFREQ_DEBUG_DRIVER=0 CPUFREQ_DEBUG_GOVERNOR=0
                        acpi_cpufreq
                        freq_table
                        cpufreq_userspace
                        cpufreq_performance
                        cpufreq

                driver enabled=0

                dummy enabled=0

                snd_seq enabled=0

          Enable a module:

                $echo "set enabled=1 <module_name>" > dynamic_printk/modules

          Disable a module:

                $echo "set enabled=0 <module_name>" > dynamic_printk/modules

          To set the level or flag value for type 'level' or 'flag':

                $echo "set level=<#> <module_name>" > dynamic_printk/modules

          Enable all modules:

                $echo "set enabled=1 all" > dynamic_printk/modules

          Disable all modules:

                $echo "set enabled=0 all" > dynamic_printk/modules

IMPLEMENTATION

The set of modules that can be dynamically controlled via 
/sys/kernel/debug/dynamic_printk/modules are created on the fly during bootup.
Meta-data is implicity associated with each 'pr_debug()', dev_dbg()' and
'dynamic_debug_enabled()' call site. This meta-data includes the module name
and the debug type, (one of boolean, flag, or level). The meta-data is
contained in a special "verbose" section of the kernel binary. So this section
is essentially scanned during bootup or module load/unload, and an internal
kernel hash data structure is created. The "verbose" section is then freed.
Thus, although the text size increases with this compile option (~2% in my 
testing), the runtime size remains the same (module the infrastructure code).

Two internal hash table are created as a hash on the module name. Each
hash table has 64 buckets. Each bucket has a 'long long' mask associated with
it, where bit 'n' set, if any module which hashes into the bucket row 
'n' is enabled. Only, if both bits are set in the corresponding mask do we make 
a function call. This function call checks to see if the level or flags are 
appropriately set and that the module is enabled before outputing the printk 
(in the case of pr_debug() or dev_dbg()), or returning true or false, in the 
case of 'dynamic_debug_enabled()'. The hashes at each call site, have been
computed during kernel compile, thus the overhead at each call site is simply
checking for bits being set in the masks. I believe this provides very low
overhead when only a handfull of modules are enabled.

thanks,

-Jason






