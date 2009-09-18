Return-Path: <linux-kernel-owner+w=401wt.eu-S1754375AbZIRVcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754375AbZIRVcI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 17:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751425AbZIRVcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 17:32:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:51977 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbZIRVcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 17:32:03 -0400
Subject: Re: [bug] /etc/profile: line 30: /dev/null: Permission denied
From: Kay Sievers <kay.sievers@vrfy.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <m14or0vul4.fsf@fess.ebiederm.org>
References: <m1y6oef08k.fsf@fess.ebiederm.org>
	 <20090917125759.GA4045@kroah.com> <m1ab0tcwep.fsf@fess.ebiederm.org>
	 <20090917185306.GA28635@elte.hu>
	 <ac3eb2510909171218k4963fc7dv8fb7549007e511aa@mail.gmail.com>
	 <alpine.LFD.2.01.0909171322210.4950@localhost.localdomain>
	 <ac3eb2510909171526ga51ecfag74af1a34a0437189@mail.gmail.com>
	 <alpine.LFD.2.01.0909171709410.4950@localhost.localdomain>
	 <1253238637.4071.10.camel@yio.site>  <m14or0vul4.fsf@fess.ebiederm.org>
Content-Type: text/plain
Date: Fri, 18 Sep 2009 23:31:53 +0200
Message-Id: <1253309513.1864.5.camel@yio.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-18 at 13:58 -0700, Eric W. Biederman wrote:
> As a special case you can implement this much
> more simply in devtmpfs_mount just do:

I sent the patch to Greg already. I like to keep the things in the
subsystem where the non-default names are set. The issue will come back
from the embedded guys, who want to do be able to do that for a few more
nodes and run their stuff completely without userspace /dev. We are also
sure never to touch anything we did not create.

> int devtmpfs_mount(const char *mountpoint)
> {
>         sys_mount("none", "dev", "devtmpfs", MS_SILENT, NULL);
> 	sys_chmod("dev/console", 0666);
> 	sys_chmod("dev/tty", 0666);
> 	sys_chmod("dev/null", 0666);
> 	sys_chmod("dev/zero", 0666);
> }
> 
> Not using sys_mount is the problem Christoph was complaining about.
> 
> Grafting dev_mount into the global namespace (instead of making
> a copy and grafting that is pretty hideous).   It means that
> vfs_path_lookup will follow mounts, and it is a reference counting
> problem.

Ah, thanks.

> You can probably oops the kernel by going into single
> user mode and unmounting devtmpfs as the code stands right now.

It's busy here, and looks fine.



This change works for me here. Do you want to send or sign that off? :)

Thanks a lot,
Kay

---
 devtmpfs.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/base/devtmpfs.c b/drivers/base/devtmpfs.c
index fd488ad..685fc05 100644
--- a/drivers/base/devtmpfs.c
+++ b/drivers/base/devtmpfs.c
@@ -316,7 +316,6 @@ out:
  */
 int devtmpfs_mount(const char *mountpoint)
 {
-	struct path path;
 	int err;
 
 	if (!dev_mount)
@@ -325,15 +324,11 @@ int devtmpfs_mount(const char *mountpoint)
 	if (!dev_mnt)
 		return 0;
 
-	err = kern_path(mountpoint, LOOKUP_FOLLOW, &path);
-	if (err)
-		return err;
-	err = do_add_mount(dev_mnt, &path, 0, NULL);
+	err = sys_mount("none", mountpoint, "devtmpfs", MS_SILENT, NULL);
 	if (err)
 		printk(KERN_INFO "devtmpfs: error mounting %i\n", err);
 	else
 		printk(KERN_INFO "devtmpfs: mounted\n");
-	path_put(&path);
 	return err;
 }
 


