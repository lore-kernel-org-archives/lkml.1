Return-Path: <linux-kernel-owner+w=401wt.eu-S932260AbXBNCks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932260AbXBNCks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Feb 2007 21:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932262AbXBNCks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Feb 2007 21:40:48 -0500
Received: from ns2.lanforge.com ([66.165.47.211]:37548 "EHLO ns2.lanforge.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260AbXBNCkr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Feb 2007 21:40:47 -0500
X-Greylist: delayed 2526 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Feb 2007 21:40:47 EST
Message-ID: <45D26CD0.1000303@candelatech.com>
Date: Tue, 13 Feb 2007 17:58:40 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Thunderbird 1.5.0.9 (X11/20070102)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: suggestion for lock debugging.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

While playing around with lockdep (nice tool!) I thought
it might be nice to store the file-name and line where
the lock was acquired.  For the generic case, this could be done
with the __FILE__ and __LINE__ compiler macros, but for highly interesting
locks (ie, rtnl in my case), you could pass in the __FILE__ and __LINE__
where rtnl_lock() is called, something like:


+++ b/include/linux/rtnetlink.h
@@ -1042,7 +1042,8 @@ __rta_reserve(struct sk_buff *skb, int attrtype, int attrlen)
  extern void rtmsg_ifinfo(int type, struct net_device *dev, unsigned change);

  /* RTNL is used as a global lock for all changes to network configuration  */
-extern void rtnl_lock(void);
+#define rtnl_lock() __rtnl_lock(__FILE__, __LINE__);
+extern void __rtnl_lock(const char* fname, int fline);
  extern void rtnl_unlock(void);
  extern int rtnl_trylock(void);

/* pass this off to lockdep and have it store the info for
* later printing, instead of this current hack below that stores
* it in a global variable...
*/
+void __rtnl_lock(const char* fname, int fline)
  {
  	mutex_lock(&rtnl_mutex);
+	rtnl_locked_fname = fname;
+	rtnl_locked_fline = fline;
  }


I have a hacked up patch that allows lockdep to save and print
this info, but I'm not clear on exactly how to pass the fname, fline info
through mutex_lock and on to lockdep's methods....

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

