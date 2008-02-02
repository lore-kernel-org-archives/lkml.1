Return-Path: <linux-kernel-owner+w=401wt.eu-S932803AbYBBJhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932803AbYBBJhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 04:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758577AbYBBJhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 04:37:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:33245 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758259AbYBBJhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 04:37:17 -0500
Date: Sat, 02 Feb 2008 18:37:08 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [2.6.24-rc8-mm1][regression?] numactl --interleave=all doesn't works on memoryless node.
Cc: kosaki.motohiro@jp.fujitsu.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>, Lee.Schermerhorn@hp.com
In-Reply-To: <20080202090914.GA27723@one.firstfloor.org>
References: <20080202165054.F491.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080202090914.GA27723@one.firstfloor.org>
Message-Id: <20080202180536.F494.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

> > 3. 2.6.24-rc8-mm1 set_mempolicy(2) behavior
> >    3.1 check nodesubset(nodemask argument, node_states[N_HIGH_MEMORY])
> >        in mpol_check_policy()
> > 
> > 	-> check failed when memmoryless node exist.
> >            (i.e. node_states[N_HIGH_MEMORY] of my machine is 0xc)
> > 
> > 4. RHEL5.1 set_mempolicy(2) behavior
> >    4.1 check nodesubset(nodemask argument, node_online_map)
> >        in mpol_check_policy().
> > 
> > 	-> check success.
> > 
> > I don't know wrong either kernel or libnuma.
> 
> When the kernel behaviour changes and breaks user space then the kernel
> is usually wrong. Cc'ed Lee S. who maintains the kernel code now.

may be yes, may be no.

I have 1 simple question. 
Why do libnuma generate bitpattern of all bit on instead
check /sys/devices/system/node/has_high_memory nor 
check /sys/devices/system/node/online?

Do you know it?

and I made simple patch that has_high_memory exposed however CONFIG_HIGHMEM disabled.
if CONFIG_HIGHMEM disabled, the has_high_memory file show 
the same as the has_normal_memory.

may be, userland process should check has_high_memory file.

but, I am not confident.
Thanks.


- kosaki



Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 drivers/base/node.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: b/drivers/base/node.c
===================================================================
--- a/drivers/base/node.c       2008-02-02 17:52:32.000000000 +0900
+++ b/drivers/base/node.c       2008-02-02 18:32:38.000000000 +0900
@@ -276,7 +276,6 @@ static SYSDEV_CLASS_ATTR(has_normal_memo
                                                                        NULL);
 static SYSDEV_CLASS_ATTR(has_cpu, 0444, print_nodes_has_cpu, NULL);

-#ifdef CONFIG_HIGHMEM
 static ssize_t print_nodes_has_high_memory(struct sysdev_class *class,
                                                 char *buf)
 {
@@ -285,15 +284,11 @@ static ssize_t print_nodes_has_high_memo

 static SYSDEV_CLASS_ATTR(has_high_memory, 0444, print_nodes_has_high_memory,
                                                                         NULL);
-#endif
-
 struct sysdev_class_attribute *node_state_attr[] = {
        &attr_possible,
        &attr_online,
        &attr_has_normal_memory,
-#ifdef CONFIG_HIGHMEM
        &attr_has_high_memory,
-#endif
        &attr_has_cpu,
 };

@@ -302,7 +297,7 @@ static int node_states_init(void)
        int i;
        int err = 0;

-       for (i = 0;  i < NR_NODE_STATES; i++) {
+       for (i = 0;  i < ARRAY_SIZE(node_state_attr); i++) {
                int ret;
                ret = sysdev_class_create_file(&node_class, node_state_attr[i]);
                if (!err)

