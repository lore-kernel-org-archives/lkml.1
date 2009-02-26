Return-Path: <linux-kernel-owner+w=401wt.eu-S1756171AbZBZLsA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171AbZBZLsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 06:48:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753636AbZBZLrv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 06:47:51 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51851 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbZBZLru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 06:47:50 -0500
Message-ID: <49A6812F.4030303@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 12:46:55 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Li Wei <W.Li@Sun.COM>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <49883CD7.2060602@linux.vnet.ibm.com> <1235643104.13052.10.camel@localhost>
In-Reply-To: <1235643104.13052.10.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Wei wrote:
> On Tue, 2009-02-03 at 13:47 +0100, Peter Oberparleiter wrote:
>> +/* write() implementation for reset file. Reset all profiling data to zero
>> + * and remove ghost nodes. */
>> +static ssize_t reset_write(struct file *file, const char __user *addr,
>> +			   size_t len, loff_t *pos)
>> +{
>> +	struct gcov_node *node;
>> +	struct gcov_node *r;
>> +
>> +	mutex_lock(&node_lock);
>> +	list_for_each_entry_safe(node, r, &all_head, all) {
>> +		if (node->info)
>> +			gcov_info_reset(node->info);
>> +		else
>> +			remove_node(node);
>> +	}
>> +	mutex_unlock(&node_lock);
>> +
>> +	return len;
>> +}
> 
> The remove_node above may have deleted the node that r points at. How
> about replacing all_head with a leaves_head that contains all leaf
> nodes, and iterate the latter instead?

You're right again - with the fix for node->parent I'm running into
kernel oopses because of this problem. But instead of creating and
maintaining a new new leaf-nodes list, I'd prefer simply restarting
the loop when remove_node has been called. This results in a bit more
computing effort but doesn't increase data complexity any more than
necessary. My proposed fix looks something like this (unless there
are objections, I'll include this one in the re-post):

---
 kernel/gcov/fs.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

Index: linux-2.6.29-rc6/kernel/gcov/fs.c
===================================================================
--- linux-2.6.29-rc6.orig/kernel/gcov/fs.c
+++ linux-2.6.29-rc6/kernel/gcov/fs.c
@@ -453,15 +453,22 @@ static ssize_t reset_write(struct file *
 			   size_t len, loff_t *pos)
 {
 	struct gcov_node *node;
-	struct gcov_node *r;
+	int restart;
 
 	mutex_lock(&node_lock);
-	list_for_each_entry_safe(node, r, &all_head, all) {
-		if (node->info)
-			gcov_info_reset(node->info);
-		else
-			remove_node(node);
-	}
+	do {
+		restart = 0;
+		list_for_each_entry(node, &all_head, all) {
+			if (node->info)
+				gcov_info_reset(node->info);
+			else if (list_empty(&node->children)) {
+				remove_node(node);
+				/* Several nodes may have gone - restart. */
+				restart = 1;
+				break;
+			}
+		}
+	} while (restart);
 	mutex_unlock(&node_lock);
 
 	return len;

