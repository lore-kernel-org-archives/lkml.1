Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZBZM4p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZBZM4p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 07:56:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbZBZM4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 07:56:36 -0500
Received: from mtagate6.de.ibm.com ([195.212.29.155]:58854 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbZBZM4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 07:56:36 -0500
Message-ID: <49A6912A.9080302@linux.vnet.ibm.com>
Date: Thu, 26 Feb 2009 13:55:06 +0100
From: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Li Wei <W.Li@Sun.COM>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Huang Ying <ying.huang@intel.com>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
References: <49883CD7.2060602@linux.vnet.ibm.com> <1235643104.13052.10.camel@localhost> <49A6812F.4030303@linux.vnet.ibm.com> <1235650122.7166.6.camel@localhost>
In-Reply-To: <1235650122.7166.6.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Wei wrote:
> On Thu, 2009-02-26 at 12:46 +0100, Peter Oberparleiter wrote:
>> necessary. My proposed fix looks something like this (unless there
>> are objections, I'll include this one in the re-post):
> 
> I'd prefer a goto. But this looks nice too. Thanks! :)

I usually try to prevent gotos that jump backwards, but on second
thought I agree that in this case it makes the code more readable.
Also a quick look confirms that similar constructs seem to be common
practice within the kernel so I'll use the goto instead:

---
 kernel/gcov/fs.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.29-rc6/kernel/gcov/fs.c
===================================================================
--- linux-2.6.29-rc6.orig/kernel/gcov/fs.c
+++ linux-2.6.29-rc6/kernel/gcov/fs.c
@@ -453,14 +453,17 @@ static ssize_t reset_write(struct file *
 			   size_t len, loff_t *pos)
 {
 	struct gcov_node *node;
-	struct gcov_node *r;
 
 	mutex_lock(&node_lock);
-	list_for_each_entry_safe(node, r, &all_head, all) {
+restart:
+	list_for_each_entry(node, &all_head, all) {
 		if (node->info)
 			gcov_info_reset(node->info);
-		else
+		else if (list_empty(&node->children)) {
 			remove_node(node);
+			/* Several nodes may have gone - restart loop. */
+			goto restart;
+		}
 	}
 	mutex_unlock(&node_lock);
 

