Return-Path: <linux-kernel-owner+w=401wt.eu-S1754370Ab0AEPVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370Ab0AEPVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 10:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754339Ab0AEPVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 10:21:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58380 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754246Ab0AEPVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 10:21:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: strict copy_from_user checks issues?
Date: Tue, 5 Jan 2010 16:20:38 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <201001051445.26149.arnd@arndb.de> <20100105055224.39f9efff@infradead.org>
In-Reply-To: <20100105055224.39f9efff@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051620.38943.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/fi3MONQFECzA3Vn42Db/ChVTRldxYizYFJAm
 OnSntnzlJn7q+GVdX7avYwCyCQ9E224Q91Sx/hZbKMeRJYD2lQ
 bkyfd9RAXs8SNV1dGakng==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Arjan van de Ven wrote:
> On Tue, 5 Jan 2010 14:45:25 +0100
> Arnd Bergmann <arnd@arndb.de> wrote:
> > 
> > I think it will get inlined on 32 bit machines or without
> > CONFIG_COMPAT, but not when CONFIG_COMPAT is enabled, because then
> > there are two call-sites.
> 
> one of them is buggy it seems;
> it passes in a shorter length, but there is no code in sight that makes
> sure that the end of the structure (the difference between the shorter
> and full length one) gets initialized to, say, zeros rather than stack
> garbage. So looks like there is at least a bug there.

The old code (until 2.6.32) always copied sizeof (struct ifreq), which
I changed in order not corrupt the user space stack.

I checked that no code in the tun driver accesses the incompatible
parts of the structure, which would require conversion rather
than simply doing a short read, so it looks correct to me, or am I
missing something?

> Would be nice if the copy (+ clear) would be pulled to the two callers
> I suspect... at which point the warning will go away too as a side
> effect.

You mean like this?

It adds some complexity and about 200 bytes of object code,
I'm not sure it's worth it.

--
[UNTESTED PATCH] tun: avoid copy_from_user size warning

For 32 bit compat code, the tun driver only copies the
fields it needs using a short length, which copy_from_user
now warns about. Moving the copy operation outside of the
main ioctl function lets us avoid the warning.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

---

 drivers/net/tun.c |  104 +++++++++++++++++++++++++++++++----------------------
 1 files changed, 61 insertions(+), 43 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 01e99f2..8eb9f38 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1111,19 +1111,14 @@ static int set_offload(struct net_device *dev, unsigned long arg)
 }
 
 static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
-			    unsigned long arg, int ifreq_len)
+			    unsigned long arg, struct ifreq *ifr)
 {
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun;
 	void __user* argp = (void __user*)arg;
-	struct ifreq ifr;
 	int sndbuf;
 	int ret;
 
-	if (cmd == TUNSETIFF || _IOC_TYPE(cmd) == 0x89)
-		if (copy_from_user(&ifr, argp, ifreq_len))
-			return -EFAULT;
-
 	if (cmd == TUNGETFEATURES) {
 		/* Currently this just means: "what IFF flags are valid?".
 		 * This is needed because we never checked for invalid flags on
@@ -1136,34 +1131,21 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	rtnl_lock();
 
 	tun = __tun_get(tfile);
-	if (cmd == TUNSETIFF && !tun) {
-		ifr.ifr_name[IFNAMSIZ-1] = '\0';
-
-		ret = tun_set_iff(tfile->net, file, &ifr);
-
-		if (ret)
-			goto unlock;
-
-		if (copy_to_user(argp, &ifr, ifreq_len))
-			ret = -EFAULT;
+	if (!tun) {
+		ret = -EBADFD;
+		if (cmd == TUNSETIFF) {
+			ifr->ifr_name[IFNAMSIZ-1] = '\0';
+			ret = tun_set_iff(tfile->net, file, ifr);
+		}
 		goto unlock;
 	}
 
-	ret = -EBADFD;
-	if (!tun)
-		goto unlock;
-
 	DBG(KERN_INFO "%s: tun_chr_ioctl cmd %d\n", tun->dev->name, cmd);
 
 	ret = 0;
 	switch (cmd) {
 	case TUNGETIFF:
-		ret = tun_get_iff(current->nsproxy->net_ns, tun, &ifr);
-		if (ret)
-			break;
-
-		if (copy_to_user(argp, &ifr, ifreq_len))
-			ret = -EFAULT;
+		ret = tun_get_iff(current->nsproxy->net_ns, tun, ifr);
 		break;
 
 	case TUNSETNOCSUM:
@@ -1234,18 +1216,16 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 
 	case SIOCGIFHWADDR:
 		/* Get hw addres */
-		memcpy(ifr.ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
-		ifr.ifr_hwaddr.sa_family = tun->dev->type;
-		if (copy_to_user(argp, &ifr, ifreq_len))
-			ret = -EFAULT;
+		memcpy(ifr->ifr_hwaddr.sa_data, tun->dev->dev_addr, ETH_ALEN);
+		ifr->ifr_hwaddr.sa_family = tun->dev->type;
 		break;
 
 	case SIOCSIFHWADDR:
 		/* Set hw address */
 		DBG(KERN_DEBUG "%s: set hw address: %pM\n",
-			tun->dev->name, ifr.ifr_hwaddr.sa_data);
+			tun->dev->name, ifr->ifr_hwaddr.sa_data);
 
-		ret = dev_set_mac_address(tun->dev, &ifr.ifr_hwaddr);
+		ret = dev_set_mac_address(tun->dev, &ifr->ifr_hwaddr);
 		break;
 
 	case TUNGETSNDBUF:
@@ -1278,35 +1258,73 @@ unlock:
 static long tun_chr_ioctl(struct file *file,
 			  unsigned int cmd, unsigned long arg)
 {
-	return __tun_chr_ioctl(file, cmd, arg, sizeof (struct ifreq));
+	struct ifreq ifr;
+	struct ifreq __user *uifr = (void *)arg;
+	int ret;
+
+	switch (cmd) {
+	case TUNSETIFF:
+	case TUNGETIFF:
+	case SIOCGIFHWADDR:
+	case SIOCSIFHWADDR:
+		if (copy_from_user(&ifr, uifr, sizeof (ifr)))
+			return -EFAULT;
+
+		ret = __tun_chr_ioctl(file, cmd, arg, &ifr);
+		if (ret < 0)
+			return ret;
+
+		if (copy_to_user(uifr, &ifr, sizeof (ifr)))
+			return -EFAULT;
+
+		return ret;
+	}
+
+	return __tun_chr_ioctl(file, cmd, arg, NULL);
 }
 
 #ifdef CONFIG_COMPAT
 static long tun_chr_compat_ioctl(struct file *file,
 			 unsigned int cmd, unsigned long arg)
 {
+	struct ifreq ifr;
+	struct compat_ifreq __user *uifr = compat_ptr(arg);
+	int ret;
+
 	switch (cmd) {
 	case TUNSETIFF:
 	case TUNGETIFF:
+	case SIOCGIFHWADDR:
+	case SIOCSIFHWADDR:
+	/*
+	 * compat_ifreq is shorter than ifreq, so we must not access beyond
+	 * the end of that structure. All fields that are used in this
+	 * driver are compatible though, we don't need to convert the
+	 * contents.
+	 */
+		memset(&ifr, 0, sizeof (ifr));
+		if (copy_from_user((struct compat_ifreq *)&ifr, uifr, sizeof (*uifr)))
+			return -EFAULT;
+
+		ret = __tun_chr_ioctl(file, cmd, 0, &ifr);
+		if (ret)
+			return ret;
+
+		if (copy_to_user(uifr, (struct compat_ifreq *)&ifr, sizeof (*uifr)))
+			return -EFAULT;
+		return ret;
+		break;
+
 	case TUNSETTXFILTER:
 	case TUNGETSNDBUF:
 	case TUNSETSNDBUF:
-	case SIOCGIFHWADDR:
-	case SIOCSIFHWADDR:
 		arg = (unsigned long)compat_ptr(arg);
 		break;
 	default:
 		arg = (compat_ulong_t)arg;
 		break;
 	}
-
-	/*
-	 * compat_ifreq is shorter than ifreq, so we must not access beyond
-	 * the end of that structure. All fields that are used in this
-	 * driver are compatible though, we don't need to convert the
-	 * contents.
-	 */
-	return __tun_chr_ioctl(file, cmd, arg, sizeof(struct compat_ifreq));
+	return __tun_chr_ioctl(file, cmd, arg, NULL);
 }
 #endif /* CONFIG_COMPAT */
 

