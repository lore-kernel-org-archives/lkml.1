Return-Path: <linux-kernel-owner+w=401wt.eu-S1753411AbZKPQnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411AbZKPQnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 11:43:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753301AbZKPQnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 11:43:12 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:52324 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbZKPQnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 11:43:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=sRkn5tOeWK3ERZ1ZTHXv5Xvf8SqjwUjPu4k5AcRJ/3s45kphBcrq/0uO14fWUoDMrP
         NwcrPh8F7dtQL4YTq5Ag9hG5O0DUTHPUj/JIGSQ3u/6vknMh0eI7Cl6ReAJqZVk5dk+Q
         vxT+qRjB+F+8gQvZiURdClohw/gyVIwJD1Ol8=
Message-ID: <4B018405.2030408@gmail.com>
Date: Mon, 16 Nov 2009 17:55:33 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Documentation: Fix NUL termination of strncpy
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the copied strings are NUL terminated.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 Documentation/accounting/getdelays.c               |    2 +-
 Documentation/hwmon/hpfall.c                       |    2 +-
 Documentation/networking/radiotap-headers.txt      |    2 +-
 .../networking/timestamping/timestamping.c         |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

Rationale (please correct me if I'm wrong):

For a larger source string, strncpy only NUL terminates when
the size argument is _less_ than sizeof(destination string).
strlcpy does this when it equals sizeof (dest), but does not
overwrite NULs in the higher chars.

Because cpumask is global I used strncpy, for the extra NULs.
devname is local so I think strlcpy can be used.
For {device,hwtstamp}.ifr_name I thought the strlcpy could
be used since ifr_name is zeroed upon creation of device and
hwtstamp.

Oh, and the parenthesis in radiotap-headers.txt should not
be there.

Roel

diff --git a/Documentation/accounting/getdelays.c b/Documentation/accounting/getdelays.c
index 6e25c26..4d71b0e 100644
--- a/Documentation/accounting/getdelays.c
+++ b/Documentation/accounting/getdelays.c
@@ -303,7 +303,7 @@ int main(int argc, char *argv[])
 				err(1, "Invalid rcv buf size\n");
 			break;
 		case 'm':
-			strncpy(cpumask, optarg, sizeof(cpumask));
+			strncpy(cpumask, optarg, sizeof(cpumask) - 1);
 			maskset = 1;
 			printf("cpumask %s maskset %d\n", cpumask, maskset);
 			break;
diff --git a/Documentation/hwmon/hpfall.c b/Documentation/hwmon/hpfall.c
index 681ec22..00477ea 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -27,7 +27,7 @@ int set_unload_heads_path(char *device)
 
 	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
 		return -EINVAL;
-	strncpy(devname, device + 5, sizeof(devname));
+	strlcpy(devname, device + 5, sizeof(devname));
 
 	snprintf(unload_heads_path, sizeof(unload_heads_path),
 				"/sys/block/%s/device/unload_heads", devname);
diff --git a/Documentation/networking/radiotap-headers.txt b/Documentation/networking/radiotap-headers.txt
index 953331c..447e004 100644
--- a/Documentation/networking/radiotap-headers.txt
+++ b/Documentation/networking/radiotap-headers.txt
@@ -126,7 +126,7 @@ int MyFunction(u8 * buf, int buflen)
 
 		case IEEE80211_RADIOTAP_ANTENNA:
 			/* radiotap uses 0 for 1st ant */
-			antenna = *iterator.this_arg);
+			antenna = *iterator.this_arg;
 			break;
 
 		case IEEE80211_RADIOTAP_DBM_TX_POWER:
diff --git a/Documentation/networking/timestamping/timestamping.c b/Documentation/networking/timestamping/timestamping.c
index a7936fe..c1acd2c 100644
--- a/Documentation/networking/timestamping/timestamping.c
+++ b/Documentation/networking/timestamping/timestamping.c
@@ -374,12 +374,12 @@ int main(int argc, char **argv)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));
-	strncpy(device.ifr_name, interface, sizeof(device.ifr_name));
+	strlcpy(device.ifr_name, interface, sizeof(device.ifr_name));
 	if (ioctl(sock, SIOCGIFADDR, &device) < 0)
 		bail("getting interface IP address");
 
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
-	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
+	strlcpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
