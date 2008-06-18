Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYFRSGa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYFRSGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 14:06:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753121AbYFRSGW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 14:06:22 -0400
Received: from ping.uio.no ([129.240.78.2]:45401 "EHLO ping.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753220AbYFRSGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 14:06:20 -0400
X-Greylist: delayed 490 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Jun 2008 14:06:20 EDT
Date: Wed, 18 Jun 2008 19:57:10 +0200
From: Carl Henrik Lunde <chlunde@ping.uio.no>
To: Andrea Righi <righi.andrea@gmail.com>
Cc: balbir@linux.vnet.ibm.com, menage@google.com, matt@bluehost.com,
       roberto@unbit.it, randy.dunlap@oracle.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] i/o bandwidth controller infrastructure
Message-ID: <20080618175710.GA2737@ping.uio.no>
References: <1212791250-32320-3-git-send-email-righi.andrea@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212791250-32320-3-git-send-email-righi.andrea@gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Exiscan-Spam-Score: -6.4 (------)
X-Exiscan-Spam-Report: SpamAssassin 3.2.3 (2007-08-08) on rossum.ping.uio.no
	Score  Rule
	* -1.4 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -5.0 PING_UIO_MAIL_IS_INTERNAL Message has never been outside
	*      129.240.0.0/16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 07, 2008 at 12:27:29AM +0200, Andrea Righi wrote:
> This is the core io-throttle kernel infrastructure. It creates the basic
> interfaces to cgroups and implements the I/O measurement and throttling
> functions.
[...]
> +void cgroup_io_account(struct block_device *bdev, size_t bytes)
[...]
> +	/* Account the I/O activity  */
> +	node->req += bytes;
> +
> +	/* Evaluate if we need to throttle the current process */
> +	delta = (long)jiffies - (long)node->last_request;
> +	if (!delta)
> +		goto out;
> +
> +	t = msecs_to_jiffies(node->req / node->iorate);
> +	if (!t)
> +		goto out;
> +
> +	sleep = t - delta;
> +	if (unlikely(sleep > 0)) {
> +		spin_unlock_irq(&iot->lock);
> +		if (__cant_sleep())
> +			return;
> +		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
> +			 current, current->comm, sleep);
> +		schedule_timeout_killable(sleep);
> +		return;
> +	}
> +
> +	/* Reset I/O accounting */
> +	node->req = 0;
> +	node->last_request = jiffies;
[...]

Did you consider using token bucket instead of this (leaky bucket?)?

I've attached a patch which implements token bucket.  Although not as
precise as the leaky bucket the performance is better at high bandwidth
streaming loads.

The leaky bucket stops at around 53 MB/s while token bucket works for
up to 64 MB/s.  The baseline (no cgroups) is 66 MB/s.

benchmark:
two streaming readers (fio) with block size 128k, bucket size 4 MB
90% of the bandwidth was allocated to one process, the other gets 10%

bw-limit: actual bw  algorithm     bw1  bw2
 5 MiB/s:  5.0 MiB/s leaky_bucket  0.5  4.5
 5 MiB/s:  5.2 MiB/s token_bucket  0.6  4.6
10 MiB/s: 10.0 MiB/s leaky_bucket  1.0  9.0
10 MiB/s: 10.3 MiB/s token_bucket  1.0  9.2
15 MiB/s: 15.0 MiB/s leaky_bucket  1.5 13.5
15 MiB/s: 15.4 MiB/s token_bucket  1.5 13.8
20 MiB/s: 19.9 MiB/s leaky_bucket  2.0 17.9
20 MiB/s: 20.5 MiB/s token_bucket  2.1 18.4
25 MiB/s: 24.4 MiB/s leaky_bucket  2.5 21.9
25 MiB/s: 25.6 MiB/s token_bucket  2.6 23.0
30 MiB/s: 29.2 MiB/s leaky_bucket  3.0 26.2
30 MiB/s: 30.7 MiB/s token_bucket  3.1 27.7
35 MiB/s: 34.3 MiB/s leaky_bucket  3.4 30.9
35 MiB/s: 35.9 MiB/s token_bucket  3.6 32.3
40 MiB/s: 39.7 MiB/s leaky_bucket  3.9 35.8
40 MiB/s: 41.0 MiB/s token_bucket  4.1 36.9
45 MiB/s: 44.0 MiB/s leaky_bucket  4.3 39.7
45 MiB/s: 46.1 MiB/s token_bucket  4.6 41.5
50 MiB/s: 47.9 MiB/s leaky_bucket  4.7 43.2
50 MiB/s: 51.0 MiB/s token_bucket  5.1 45.9
55 MiB/s: 50.5 MiB/s leaky_bucket  5.0 45.5
55 MiB/s: 56.2 MiB/s token_bucket  5.6 50.5
60 MiB/s: 52.9 MiB/s leaky_bucket  5.2 47.7
60 MiB/s: 61.0 MiB/s token_bucket  6.1 54.9
65 MiB/s: 53.0 MiB/s leaky_bucket  5.4 47.6
65 MiB/s: 63.7 MiB/s token_bucket  6.6 57.1
70 MiB/s: 53.8 MiB/s leaky_bucket  5.5 48.4
70 MiB/s: 64.1 MiB/s token_bucket  7.1 57.0


diff --git a/block/blk-io-throttle.c b/block/blk-io-throttle.c
index 804df88..9ed0c7c 100644
--- a/block/blk-io-throttle.c
+++ b/block/blk-io-throttle.c
@@ -40,7 +40,8 @@ struct iothrottle_node {
 	struct rb_node node;
 	dev_t dev;
 	unsigned long iorate;
-	unsigned long req;
+	long bucket_size; /* Max value for t */
+	long t;
 	unsigned long last_request;
 };
 
@@ -180,18 +181,20 @@ static ssize_t iothrottle_read(struct cgroup *cont,
 	iothrottle_for_each(n, &iot->tree) {
 		struct iothrottle_node *node =
 				rb_entry(n, struct iothrottle_node, node);
-		unsigned long delta = (long)jiffies - (long)node->last_request;
+		unsigned long delta = (((long)jiffies - (long)node->last_request) * 1000) / HZ;
 
 		BUG_ON(!node->dev);
 		s += snprintf(s, nbytes - (s - buffer),
 				  "=== device (%u,%u) ===\n"
 				  "bandwidth-max: %lu KiB/sec\n"
-				  "    requested: %lu bytes\n"
-				  " last request: %lu jiffies\n"
-				  "        delta: %lu jiffies\n",
+				  "bucket size  : %ld KiB\n"
+				  "bucket fill  : %ld KiB (after last request)\n"
+				  "last request : %lu ms ago\n",
 				  MAJOR(node->dev), MINOR(node->dev),
-				  node->iorate, node->req,
-				  node->last_request, delta);
+				  node->iorate,
+				  node->bucket_size / 1024,
+				  node->t / 1024,
+				  delta);
 	}
 	spin_unlock_irq(&iot->lock);
 	buffer[nbytes] = '\0';
@@ -220,21 +223,33 @@ static inline dev_t devname2dev_t(const char *buf)
 	return ret;
 }
 
-static inline int iothrottle_parse_args(char *buf, size_t nbytes,
-					dev_t *dev, unsigned long *val)
+static inline int iothrottle_parse_args(char *buf, size_t nbytes, dev_t *dev,
+					unsigned long *iorate,
+					unsigned long *bucket_size)
 {
-	char *p;
+	char *ioratep, *bucket_sizep;
 
-	p = memchr(buf, ':', nbytes);
-	if (!p)
+	ioratep = memchr(buf, ':', nbytes);
+	if (!ioratep)
 		return -EINVAL;
-	*p++ = '\0';
+	*ioratep++ = '\0';
+
+	bucket_sizep = memchr(ioratep, ':', nbytes + ioratep - buf);
+	if (!bucket_sizep)
+		return -EINVAL;
+	*bucket_sizep++ = '\0';
 
 	*dev = devname2dev_t(buf);
 	if (!*dev)
 		return -ENOTBLK;
 
-	return strict_strtoul(p, 10, val);
+	if (strict_strtoul(ioratep, 10, iorate))
+		return -EINVAL;
+
+	if (strict_strtoul(bucket_sizep, 10, bucket_size))
+		return -EINVAL;
+
+	return 0;
 }
 
 static ssize_t iothrottle_write(struct cgroup *cont,
@@ -247,7 +262,7 @@ static ssize_t iothrottle_write(struct cgroup *cont,
 	struct iothrottle_node *node, *tmpn = NULL;
 	char *buffer, *tmpp;
 	dev_t dev;
-	unsigned long val;
+	unsigned long iorate, bucket_size;
 	int ret;
 
 	if (unlikely(!nbytes))
@@ -265,7 +280,7 @@ static ssize_t iothrottle_write(struct cgroup *cont,
 	buffer[nbytes] = '\0';
 	tmpp = strstrip(buffer);
 
-	ret = iothrottle_parse_args(tmpp, nbytes, &dev, &val);
+	ret = iothrottle_parse_args(tmpp, nbytes, &dev, &iorate, &bucket_size);
 	if (ret)
 		goto out1;
 
@@ -284,7 +299,7 @@ static ssize_t iothrottle_write(struct cgroup *cont,
 	iot = cgroup_to_iothrottle(cont);
 
 	spin_lock_irq(&iot->lock);
-	if (!val) {
+	if (!iorate) {
 		/* Delete a block device limiting rule */
 		iothrottle_delete_node(iot, dev);
 		ret = nbytes;
@@ -293,8 +308,9 @@ static ssize_t iothrottle_write(struct cgroup *cont,
 	node = iothrottle_search_node(iot, dev);
 	if (node) {
 		/* Update a block device limiting rule */
-		node->iorate = val;
-		node->req = 0;
+		node->iorate = iorate;
+		node->bucket_size = bucket_size * 1024;
+		node->t = 0;
 		node->last_request = jiffies;
 		ret = nbytes;
 		goto out3;
@@ -307,8 +323,9 @@ static ssize_t iothrottle_write(struct cgroup *cont,
 	node = tmpn;
 	tmpn = NULL;
 
-	node->iorate = val;
-	node->req = 0;
+	node->iorate = iorate;
+	node->bucket_size = bucket_size * 1024;
+	node->t = 0;
 	node->last_request = jiffies;
 	node->dev = dev;
 	ret = iothrottle_insert_node(iot, node);
@@ -355,7 +372,7 @@ void cgroup_io_account(struct block_device *bdev, size_t bytes)
 {
 	struct iothrottle *iot;
 	struct iothrottle_node *node;
-	unsigned long delta, t;
+	unsigned long delta;
 	long sleep;
 
 	if (unlikely(!bdev))
@@ -370,36 +387,37 @@ void cgroup_io_account(struct block_device *bdev, size_t bytes)
 	spin_lock_irq(&iot->lock);
 
 	node = iothrottle_search_node(iot, bdev->bd_inode->i_rdev);
-	if (!node || !node->iorate)
-		goto out;
-
-	/* Account the I/O activity  */
-	node->req += bytes;
+	if (!node || !node->iorate) {
+		spin_unlock_irq(&iot->lock);
+		return;
+	}
 
-	/* Evaluate if we need to throttle the current process */
+	/* Add tokens for time elapsed since last read */
 	delta = (long)jiffies - (long)node->last_request;
-	if (!delta)
-		goto out;
+	if (delta) {
+		node->last_request = jiffies;
+		node->t += (node->iorate * 1024 * delta) / HZ;
 
-	t = msecs_to_jiffies(node->req / node->iorate);
-	if (!t)
-		goto out;
+		if (node->t > node->bucket_size)
+			node->t = node->bucket_size;
+	}
 
-	sleep = t - delta;
-	if (unlikely(sleep > 0)) {
-		spin_unlock_irq(&iot->lock);
-		if (__cant_sleep())
-			return;
-		pr_debug("io-throttle: task %p (%s) must sleep %lu jiffies\n",
-			 current, current->comm, sleep);
-		schedule_timeout_killable(sleep);
-		return;
+	/* Account the I/O activity  */
+	node->t -= bytes;
+
+	if (node->t < 0) {
+		sleep = (-node->t) * HZ / (node->iorate * 1024);
+	} else {
+		sleep = 0;
 	}
 
-	/* Reset I/O accounting */
-	node->req = 0;
-	node->last_request = jiffies;
-out:
 	spin_unlock_irq(&iot->lock);
+
+	if (sleep && !__cant_sleep()) {
+		pr_debug("io-throttle: %s[%d] must sleep %ld jiffies\n",
+			 current->comm, current->pid, sleep);
+
+		schedule_timeout_killable(sleep);
+	}
 }
 EXPORT_SYMBOL(cgroup_io_account);

-- 
Carl Henrik
