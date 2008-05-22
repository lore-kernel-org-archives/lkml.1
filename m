Return-Path: <linux-kernel-owner+w=401wt.eu-S1760761AbYEVVO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761AbYEVVO4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761347AbYEVVO0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:14:26 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762717AbYEVVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:14:24 -0400
Date: Thu, 22 May 2008 17:13:31 -0400
From: Jason Baron <jbaron@redhat.com>
To: akpm@linux-foundation.org, joe@perches.com, greg@kroah.com,
       nick@nick-andrew.net, randy.dunlap@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: [patch 0/8] debug printk infrastructure
Message-ID: <20080522211331.GA28070@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

So i've attempted to make this infrastrucutre general enough to be used by the
kernel as a whole. The basic interfaces i'm using are the basic, 'pr_debug()',
and 'dev_dbg()' calls. And then i've added:

-register_dev_dbg_handler(parent, type, max, init)
This registers a handler that can support level, or flag printks. 'type' is
either 'TYPE_LEVEL' or 'TYPE_FLAG'. The 'parent' field can be used to support
a hierarchical debugging between modules, for example where we want to share
the same levels across modules. 'init' is the initial setting for the flag
or level. 'max' is currently unused and probably should be discarded.

-dev_dbg_level(value, dev, format, ...)
This call is used by code in the core driver as its interface into 'printk'.
'value' is the level or flag value for the particular printk. So modules can
do: #define dprintk dev_dbg_level(value, dev, format, ...)

-dev_dbg_enabled(value)
This call is used to allow the infrastructure to be more flexible and handle
blocks of printks or even blocks of other debugging code.

-'pr_debug' and 'dev_dbg' can continue to be used as before (no API change),
but this infrastructure automatically detects where these calls are and displays
the modules that have them in a debugfs file: debug/dynamic_printk/modules

The debugfs file, then lists all the modules that can be 'enabled' for dynamic
printk calls. Currently, the file has a 4 column format (excerpt from my system:

<module_name> <enabled/disabled> <current level/flag setting> <# of call sites>

8250 0 0 2
acpi_cpufreq 0 0 1
aio 0 0 24
backlight 0 0 3

I've converted a few subsysmts to this infrastructure to provide some examples
of what it can do: module.c bonding aio and cpufreq (including sub-drivers).

I realize the code is a bit rough around the edges, but the basic idea is here, 
and i'm looking for feedback on the approach.

todo:

*free memory used in text sections to detect call sites
*provide potential level settings in the debugfs file
*convert more modules/subsystems
*tidy up lib/dynamic_printk.c

thanks,

-Jason



