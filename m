Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbXFMKSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbXFMKSA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756761AbXFMKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:17:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46737 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756635AbXFMKRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:17:52 -0400
Date: Wed, 13 Jun 2007 15:47:38 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       vatsa@in.ibm.com, ebiederm@xmission.com, haveblue@us.ibm.com,
       svaidy@linux.vnet.ibm.com, balbir@in.ibm.com, pj@sgi.com, cpw@sgi.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 01/10] Containers(V10): Basic container framework
Message-ID: <20070613101738.GA10827@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20070529130104.461765000@menage.corp.google.com> <20070529132142.052411000@menage.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070529132142.052411000@menage.corp.google.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, May 29, 2007 at 06:01:05AM -0700, menage@google.com wrote:
> +1.5 How do I use containers ?
> +--------------------------
> +
> +To start a new job that is to be contained within a container, using
> +the "cpuset" container subsystem, the steps are something like:
> +
> + 1) mkdir /dev/container
> + 2) mount -t container -ocpuset cpuset /dev/container
> + 3) Create the new container by doing mkdir's and write's (or echo's) in
> +    the /dev/container virtual file system.
> + 4) Start a task that will be the "founding father" of the new job.
> + 5) Attach that task to the new container by writing its pid to the
> +    /dev/container tasks file for that container.
> + 6) fork, exec or clone the job tasks from this founding father task.
> +
> +For example, the following sequence of commands will setup a container
> +named "Charlie", containing just CPUs 2 and 3, and Memory Node 1,
> +and then start a subshell 'sh' in that container:
> +
> +  mount -t container cpuset -ocpuset /dev/container
> +  cd /dev/container
> +  mkdir Charlie
> +  cd Charlie

This example does not work. To do so we need to do

  /bin/echo 2-3 > cpus
  /bin/echo 1 > mems

> +  /bin/echo $$ > tasks
> +  sh
> +  # The subshell 'sh' is now running in container Charlie
> +  # The next line should display '/Charlie'
> +  cat /proc/self/container

The following patch does that.

thanks and regards
Dhaval

----------------------

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

 
diff -uprN linux-2.6.22-rc4/Documentation/containers.txt old/Documentation/containers.txt
--- linux-2.6.22-rc4/Documentation/containers.txt	2007-06-13 15:38:30.000000000 +0530
+++ old/Documentation/containers.txt	2007-06-13 10:56:49.000000000 +0530
@@ -310,6 +310,8 @@ and then start a subshell 'sh' in that c
   cd /dev/container
   mkdir Charlie
   cd Charlie
+  /bin/echo 2-3 > cpus
+  /bin/echo 1 > mems
   /bin/echo $$ > tasks
   sh
   # The subshell 'sh' is now running in container Charlie
