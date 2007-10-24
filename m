Return-Path: <linux-kernel-owner+w=401wt.eu-S1760985AbXJXSei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760985AbXJXSei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 14:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018AbXJXSea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 14:34:30 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:35760 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755450AbXJXSe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 14:34:29 -0400
Date: Wed, 24 Oct 2007 20:34:57 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/taskstats.c: fix bogus nlmsg_free()
Message-ID: <20071024183457.GE30533@stusta.de>
References: <20071024162554.GC30533@stusta.de> <471F822A.2030904@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <471F822A.2030904@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2007 at 11:04:34PM +0530, Balbir Singh wrote:
> Adrian Bunk wrote:
> > We'd better not nlmsg_free on a pointer containing an undefined value
> > (and without having anything allocated)...
> > 
> > Spotted by the Coverity checker.
> > 
> > Signed-off-by: Adrian Bunk <bunk@kernel.org>
> > 
> > ---
> > 
> >  kernel/taskstats.c |   12 ++++++------
> >  1 file changed, 6 insertions(+), 6 deletions(-)
> > 
> > --- linux-2.6/kernel/taskstats.c.old	2007-10-23 19:01:07.000000000 +0200
> > +++ linux-2.6/kernel/taskstats.c	2007-10-23 19:21:54.000000000 +0200
>...
> >  		if (rc < 0)
> > -			goto err;
> > +			return rc;
> > 
> 
> We miss a fput_light() here

Sorry, my fault.

> >  		na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
> >  					sizeof(struct cgroupstats));
> >  		stats = nla_data(na);
> >  		memset(stats, 0, sizeof(*stats));
> > 
> >  		rc = cgroupstats_build(stats, file->f_dentry);
> > +
> > +		fput_light(file, fput_needed);
> > +
> 
> I don't understand this movement, it makes code reading a bit odd too.
> rc is the result, but we check the result after fput_light?
>...

I considered it more odd to read


                rc = cgroupstats_build(stats, file->f_dentry);
                if (rc < 0)
                        goto err;

                fput_light(file, fput_needed);
                return send_reply(rep_skb, info->snd_pid);
err:
                fput_light(file, fput_needed);
		nlmsg_free(rep_skb);


But that's just personal taste.

Anyway, duplicating the same fput_light() call two or three times isn't 
nice.

Originally I had the bigger patch below and considered it too big for 
only this fix, but now I think it might be appropriate.

If you ignore whitespace when diff'ing, then all it does is:

<--  snip  -->

@@ -398,7 +398,9 @@ static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	file = fget_light(fd, &fput_needed);
-	if (file) {
+	if (!file)
+		return 0;
+
 		size = nla_total_size(sizeof(struct cgroupstats));
 
 		rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
@@ -412,17 +414,15 @@ static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 		memset(stats, 0, sizeof(*stats));
 
 		rc = cgroupstats_build(stats, file->f_dentry);
-		if (rc < 0)
+	if (rc < 0) {
+		nlmsg_free(rep_skb);
 			goto err;
-
-		fput_light(file, fput_needed);
-		return send_reply(rep_skb, info->snd_pid);
 	}
 
+	rc = send_reply(rep_skb, info->snd_pid);
+
 err:
-	if (file)
 		fput_light(file, fput_needed);
-	nlmsg_free(rep_skb);
 	return rc;
 }
 
<--  snip  -->


Is this patch OK for you?


cu
Adrian


<--  snip  -->


We'd better not nlmsg_free on a pointer containing an undefined value
(and without having anything allocated).

Spotted by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/taskstats.c |   36 ++++++++++++++++++------------------
 1 file changed, 18 insertions(+), 18 deletions(-)

eedd297ac36b5d92fc38b937677ba40dc6df1cd0 
diff --git a/kernel/taskstats.c b/kernel/taskstats.c
index 354e74b..07e86a8 100644
--- a/kernel/taskstats.c
+++ b/kernel/taskstats.c
@@ -398,31 +398,31 @@ static int cgroupstats_user_cmd(struct sk_buff *skb, struct genl_info *info)
 
 	fd = nla_get_u32(info->attrs[CGROUPSTATS_CMD_ATTR_FD]);
 	file = fget_light(fd, &fput_needed);
-	if (file) {
-		size = nla_total_size(sizeof(struct cgroupstats));
+	if (!file)
+		return 0;
 
-		rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
-					size);
-		if (rc < 0)
-			goto err;
+	size = nla_total_size(sizeof(struct cgroupstats));
 
-		na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
-					sizeof(struct cgroupstats));
-		stats = nla_data(na);
-		memset(stats, 0, sizeof(*stats));
+	rc = prepare_reply(info, CGROUPSTATS_CMD_NEW, &rep_skb,
+				size);
+	if (rc < 0)
+		goto err;
 
-		rc = cgroupstats_build(stats, file->f_dentry);
-		if (rc < 0)
-			goto err;
+	na = nla_reserve(rep_skb, CGROUPSTATS_TYPE_CGROUP_STATS,
+				sizeof(struct cgroupstats));
+	stats = nla_data(na);
+	memset(stats, 0, sizeof(*stats));
 
-		fput_light(file, fput_needed);
-		return send_reply(rep_skb, info->snd_pid);
+	rc = cgroupstats_build(stats, file->f_dentry);
+	if (rc < 0) {
+		nlmsg_free(rep_skb);
+		goto err;
 	}
 
+	rc = send_reply(rep_skb, info->snd_pid);
+
 err:
-	if (file)
-		fput_light(file, fput_needed);
-	nlmsg_free(rep_skb);
+	fput_light(file, fput_needed);
 	return rc;
 }
 

