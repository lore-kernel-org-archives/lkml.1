Return-Path: <linux-kernel-owner+w=401wt.eu-S1755460AbZBEH1l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460AbZBEH1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 02:27:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752776AbZBEH1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 02:27:31 -0500
Received: from mga01.intel.com ([192.55.52.88]:19758 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527AbZBEH1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 02:27:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,384,1231142400"; 
   d="scan'208";a="662945707"
Message-ID: <498A94E0.2080306@intel.com>
Date: Thu, 05 Feb 2009 15:27:28 +0800
From: "Zhao, Yu" <yu.zhao@intel.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       balajirrao@gmail.com, laurent.riffard@free.fr, balajirrao@openmoko.org
Subject: Re: linux-next: Tree for March 7: slab corruptions
References: <498A7463.4010603@intel.com> <20090205053802.GA8355@kroah.com>
In-Reply-To: <20090205053802.GA8355@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Feb 05, 2009 at 01:08:51PM +0800, Zhao, Yu wrote:
>> Hi Greg,
>>
>> It looks like following fix is not in Linus' tree. Can you please queue it?
>>
>> http://lkml.org/lkml/2008/3/8/155
> 
> Queue what?  That is a message from over a year ago, are you seeing a
> problem in mainline in this area?  If so, do you have a proposed fix for
> it?
> 

Yes, I'm seeing 'kobject (ffff8800bf03b908): tried to init an initialized
object, something is seriously wrong'. The warning is fired when re-initializing
a kobject that has been deleted while its state remains `initialized'. Following
is the fix.


This patch fixes kobject_cleanup by marking the kobject as uninitialized
when we cleanup to allow kobjects to be reused.

Tested-by: Laurent Riffard <laurent.riffard@free.fr>
Signed-off-by: Balaji Rao <balajirrao@gmail.com>
Signed-off-by: Yu Zhao <yu.zhao@intel.com>
---
 lib/kobject.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 0487d1f..9f46f4f 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -540,6 +540,9 @@ static void kobject_cleanup(struct kobject *kobj)
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
 
+	/* set the state to uninitialized */
+	kobj->state_initialized = 0;
+
 	if (t && !t->release)
 		pr_debug("kobject: '%s' (%p): does not have a release() "
 			 "function, it is broken and must be fixed.\n",
-- 
1.6.1

