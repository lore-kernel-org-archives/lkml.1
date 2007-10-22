Return-Path: <linux-kernel-owner+w=401wt.eu-S1754744AbXJVSkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744AbXJVSkU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2007 14:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752231AbXJVSkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Oct 2007 14:40:08 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52267 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752499AbXJVSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2007 14:40:07 -0400
Date: Mon, 22 Oct 2007 11:40:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anas Nashif <nashif@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Marek Dabek <marek.dabek@intel.com>
Subject: Re: [PATCH] Intel Manageability Engine Interface driver
Message-Id: <20071022114001.40470c15.akpm@linux-foundation.org>
In-Reply-To: <471CDC5E.4010300@linux.intel.com>
References: <471CDC5E.4010300@linux.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Oct 2007 13:22:38 -0400 Anas Nashif <nashif@linux.intel.com> wrote:

> The Manageability Engine Interface (aka HECI) allows applications to 
> communicate with the Intel(R) Manageability Engine (ME) firmware.
> 
> It is meant to be used by user-space manageability applications to
> access ME features such as Intel(R) Active Management Technology,
> Intel(R) Quiet System Technology and ASF.
> 
> The patch is large so I'm placing the diff on the web for download
> rather than attaching it here.  Download:
> 
> http://download.openamt.org/intel-MEI.diff

Please get the patches mailed out somehow.  Consider splitting the patch
up.  I think you could send it as-is (200k will fit, I believe) but it's
rather too large to review effectively.

The code looks good from a quick scan.  Immediate impressions from a
quick scan, mainly trivia:



- Consider using open-coded "0" in place of ESUCCESS

- Remove #pragme pack(1), use __attribute__((packed))

- Why does a new driver have "additional char device for legacy mode"?

- Remove the INFO(), ERR() and WARN() macros, just open-code the printk calls

- Remove the commented-out DEF_PARM, HECI_DEBUG, any others

- You can't have a global variable called "debug"!

- Remove private definitions of TRUE and FALSE.  Use standard "true" and
  "false" or just open-code 0 and 1.

- This:

+     /**
+      * virtual void GetParam(const char* UserParam);
+      * read write messages to/from heci fw
+      */

  appears to be dead code, should be called get_param, should use
  tabstops not spaces

- These:

+#define SHUTDOWN_METHOD(method) .shutdown = method,
+#define HECI_REBOOT_NOTIFIER(reboot_notifier, driver, reboot_function)
+#define REGISTER_REBOOT_NOTIFIER(reboot_notifier)
+#define UNREGISTER_REBOOT_NOTIFIER(reboot_notifier)
+#define heci_reboot_notifier

  will be unpopular.  See if they can be removed via suitable means?

- heci_init.c has these:

+/**
+ *  heci init function prototypes
+ */
+int host_start_message(struct iamt_heci_device *dev);
+int host_enum_clients_message(struct iamt_heci_device *dev);
+int allocate_me_clents_storage(struct iamt_heci_device *dev);
+void heci_disable(struct iamt_heci_device *dev);
+void host_init_wd(struct iamt_heci_device *dev);
+void host_init_legacy(struct iamt_heci_device *dev);
+int heci_wait_event_int_timeout(struct iamt_heci_device *dev, long timeout);

  which are extern-declarations-in-C which checkpatch failed to detect. 
  They should be placed in a header file or just removed.

- please review all global symbols, check that they really do need to be
  global, and that they have suitable names (ie: not like "debug")

- mysterious msleep(100) in host_start_message()?  Needs a comment.

- Please prefer to put a blank line between the declaration of locals and
  the start of code in each function.

- Here:

+		if (0 == memcmp(&heci_wd_guid,

  we boringly prefer "if (foo == 0)" rather than "if (0 == foo)".  (lots
  of places).

- The changelog could do with some expansion.  What is "Intel(R)
  Manageability Engine (ME) firmware"?  Why do we want to include this code
  in Linux?  What value has it to our users, etc?  Bascially: tell us more
  stuff.


