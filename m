Return-Path: <linux-kernel-owner+w=401wt.eu-S1752255AbYGAFLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255AbYGAFLT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 01:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751024AbYGAFLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 01:11:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58398 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751005AbYGAFLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 01:11:07 -0400
Date: Mon, 30 Jun 2008 22:08:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Subject: Re: [PATCH 0/8] dynamic debug
Message-Id: <20080630220858.e304b244.akpm@linux-foundation.org>
In-Reply-To: <20080613185733.GA8813@redhat.com>
References: <20080613185733.GA8813@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Jun 2008 14:57:33 -0400 Jason Baron <jbaron@redhat.com> wrote:

> 
> hi Andrew,
> 
> thanks for reviewing the last set of patches. In this iteration, I've
> attempted to simplify the interfaces, and provide a better explanation
> for the patches.
> 
> PROBLEM
> 
> Each kernel sub-system seems to have its own way of dealing with debugging 
> statements. Some of these methods include 'dprintk', 'pr_debug', 'dev_debug', 
> 'DEBUGP'. There are also a myriad of ways of enabling these statements. Some
> require CONFIG_ parameters to be set, some provide /proc interfaces, while
> others require 'DEBUG' to be set in header files. Most of these methods also
> require kernel re-compiles in order to set the appropriate knobs.
> 
> SOLUTION
> 
> I've attempted to standardize how how the kernel deals with debugging 
> statements, both from the user as well as the kernel perspective. Why aren't
> these debug statements made into printk(KERN_DEBUG), and be done with it? The
> problem here is that 'dprintk', 'pr_debug', etc. were introduced b/c they
> are often provide too verbose a level of output, could potentially adversly
> affect system performance if they were always enabled, and they clutter up the 
> system logs.
> 
> I've introduced CONFIG_DYNAMIC_PRINTK_DEBUG, which when enabled centralizes
> control of debugging statements on a per-module basis in one /proc file,
> currently, <debugfs>/dynamic_printk/modules. When, CONFIG_DYNAMIC_PRINTK_DEBUG,
> is not set, debugging statements can still be enabled as before, often by
> defining 'DEBUG' for the proper compilation unit. Thus, this patch set has not
> affect when CONFIG_DYNAMIC_PRINTK_DEBUG is not set. The rest of the discussion
> deals with the case where CONFIG_DYNAMIC_PRINTK_DEBUG is set.
> 
> INTERFACE - userspace
> 
> The file <debugfs>/dynamic_printk/modules is formatted as:
> 
> <module_name><enabled/disabled><debug type><level setting><flags><module names>

Six fields

> $cat /sys/kernel/debug/dynamic_printk/modules
> 
> uhci_hcd 0 boolean 0

But only four fields here.

I assume the remaining two are optional?

If so, what happens if "flags" is empty and "module names" is
non-empty?  That's unparseable.

> dock 0 boolean 0
> mount 0 boolean 0
> main 0 boolean 0
> driver 0 boolean 0
> cpufreq_shared 0 flag 0
>   CPUFREQ_DEBUG_CORE CPUFREQ_DEBUG_DRIVER CPUFREQ_DEBUG_GOVERNOR
>   acpi_cpufreq freq_table cpufreq_userspace cpufreq
> 
> <module_name> : Name of the module in which the debug call resides
> <enabled/disabled> : whether the the messages are enabled or not
> <debug type> : types are 'boolean', 'flag', or 'level'. 'boolean' is
>                is simply on/off. 'Flag' allows different flags to be turned on or
>                off. 'Level' means that all messages above a certain level are
>                enabled.
> <level setting> : This the current value if 'flag' or 'level' is set
> <flags> : names of the flags that can be set if 'flag' type is set
> <module names> : name of modules in the grouping.

How about:

> Enable a module:
> 
> 	$echo "enable <module_name>" > dynamic_printk/modules

	echo 1 > dynamic_printk/modules/module_name/enable

> Disable a module:
> 
> 	$echo "disable <module_name>" > dynamic_printk/modules

	echo 0 > dynamic_printk/modules/module_name/disable

> To set the level or flag value for type 'level' or 'flag':
> 
> 	$echo "set level=<#> <module_name>" > dynamic_printk/modules

	echo # > dynamic_printk/modules/module_name/level

> Enable all modules:
> 
> 	$echo "add all" > dynamic_printk/modules

	remove this

> Disable all modules:
> 
> 	$echo "remove all" > dynamic_printk/modules

	remove this

?

> INTERFACE - kernel
> 
> I've tried to make the kernel interface as simple as possible. 'pr_debug()' and
> 'dev_dbg()' calls remain exactly the same, however the kernel now
> automatically recognizes these calls, and creates entries in 
> /sys/kernel/debug/dynamic_printk/modules.
> 
> For more sophisticated types of debugging i've introduced 1 new interface:
> 
> int dynamic_dbg_enabled(type, level, current_level);
> 
> 'dynamic_dbg_enabled' returns true (1) or false (0), depending on the settings
> in /sys/kernel/debug/dynamic_printk/modules. This allows printks or even
> blocks of code to be conditionally executed via:
> 
> if (dynamic_dbg_enabled() {
> 	<code block>;
> }

By what means is the module_name identified in dynamic_dbg_enabled()? 
Implicitly THIS_MODULE?

If so, what happens if the "module" is linked into vmlinux?  Or if
we're using this for, say, the CPU scheduler?

> There are 3 possible values for 'type':
> 
> 'TYPE_BOOLEAN' : this simply means the dynamic_dbg_enabled() is toggled on/off
> 'TYPE_FLAG' : this allows the dynamic_dbg_enabled() to be associated with
> 	      a set of flags and a 'call flag'. The 'call flag' is associated
> 	      with a particular dynamic_dbg_enabled() call, and if the 'call
> 	      flag' is set in the flag set it return true o.t. false.
> 'TYPE_LEVEL' : Associates dynamic_dbg_enabled() with global level and a specific
>                level for the call site. If the (specific level) < (global level)
>                returns true o.t. false.
> 
> Its probably best explained with an example (taken from cpufreq.c):
> 
> -#define dprintk(msg...) cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "gx-suspmod", msg)
> +#define dprintk(msg...) do { \
> +       if (dynamic_dbg_enabled(TYPE_FLAG, CPUFREQ_DEBUG_DRIVER, cpufreq_debug)) \
> +               cpufreq_debug_printk(CPUFREQ_DEBUG_DRIVER, "gx-suspmod", msg); \
> +       } while (0)
> 
> So, now instead of calling cpufreq_debug_printk directly, we've made it
> contingent on 'dynamic_dbg_enabled()' call. The 'cpufreq' driver uses 'TYPE_FLAG',
> which allows invidual bits of flags to control the debugging level for cpufreq
> driver. The use of dynamic_dbg_enabled() automatically creates an entry in the
> /sys/kernel/debug/dynamic_printk/modules file, as was the case for 'pr_debug()'
> and 'dev_dbg()'. 'CPUFREQ_DEBUG_DRIVER' specifies the flag bit that needs to be
> set in order for cpufreq_debug_printk() to return true.
> 
> By default, each dynamic_dbg_enabled() call implicity, sets its module, and its
> debug type. However, modules can override these implicit types by including
> a few special #define. For, example for cpufreq, the #defines are:
> 
> #undef DYNAMIC_DEBUG_NUM_FLAGS
> #define DYNAMIC_DEBUG_NUM_FLAGS "3"
> 
> #undef DYNAMIC_DEBUG_FLAG_NAMES
> #define DYNAMIC_DEBUG_FLAG_NAMES "CPUFREQ_DEBUG_CORE,CPUFREQ_DEBUG_DRIVER,CPUFREQ_DEBUG_GOVERNOR"
> 
> #undef DYNAMIC_DEBUG_TYPE
> #define DYNAMIC_DEBUG_TYPE "2"
> 
> #undef DYNAMIC_DEBUG_MODNAME
> #define DYNAMIC_DEBUG_MODNAME "cpufreq_shared"
> 
> 
> 'DYNAMIC_DEBUG_NUM_FLAGS' : number of flags the module has
> 'DYNAMIC_DEBUG_FLAG_NAMES' : the names of these flags
> 'DYNAMIC_DEBUG_TYPE' : can be one of 'TYPE_BOOLEAN or 0', 'TYPE_LEVEL or 1', or 
> 			'TYPE_FLAG or 2'
> 'DYNAMIC_DEBUG_MODNAME' : overrides the default module name, for example to allow
> 			  different compilation units to share the same flags.
> 
> 
> IMPLEMENTATION
> 
> The set of modules that can be dynamically controlled via 
> /sys/kernel/debug/dynamic_printk/modules are created on the fly during bootup.
> Meta-data is implicity associated with each 'pr_debug()', dev_dbg()' and
> 'dynamic_debug_enabled()' call site. This meta-data includes the module name
> and the debug type, (one of boolean, flag, or level). The meta-data is
> contained in a special "verbose" section of the kernel binary. So this section
> is essentially scanned during bootup or module load/unload, and an internal
> kernel hash data structure is created. The "verbose" section is then freed.
> Thus, although the text size increases with this compile option (~2% in my 
> testing), the runtime size remains the same.
> 
> The internal hash table that is created is a hash on the module name. The
> hash table has 32 buckets. Each bucket has a per-cpu 'int' type associated with
> it. This 'int' has bit 'n' set, if any module which hashes into the bucket row 
> 'n' is enabled. Thus, when debugging is disabled we are testing a bit in a per-cpu
> integer. Only, if the bit is enabled do we make a function call. This function
> call checks to see if the level or flags are appropriately set and that the module
> is enabled before outputing the printk (in the case of pr_debug() or dev_dbg()), or
> returning true or false, in the case of 'dynamic_debug_enabled()'.
> 
> TODO
> 
> -allow modules to be set by using flag names
> -fix up parsing in /proc file
> -possibly move control file out of debugfs
> -convert more modules to the infrastructure

Looks promising, thanks.  I haven't looked at the implementation yet. 
And I probably won't, this time around :( Still recovering from the
week off.

