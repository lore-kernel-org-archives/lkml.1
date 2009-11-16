Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbZKPSjf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbZKPSjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 13:39:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752163AbZKPSje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 13:39:34 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:64262 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbZKPSjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 13:39:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=qDPIrQXv5YDEDNIpHt1HHGe4Cn8bC8qSK/5nS/e2kwlZhkhH2hJjGbe007r5mNBTxZ
         essb5G9ejg0IhVbMCyKmLDIRP/J1QsA24wewVIJEtJCHXqzER0mw3K9eVaZSZHrmtZNI
         l3xt7V7VjzUyaHt/CwwKg1fY6F4MbYor4Sp5Y=
Message-ID: <4B019F52.50509@gmail.com>
Date: Mon, 16 Nov 2009 19:52:02 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, David Wagner <daw@cs.berkeley.edu>
Subject: Re: [PATCH] Documentation: Fix NUL termination of strncpy
References: <4B018405.2030408@gmail.com>
In-Reply-To: <4B018405.2030408@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ensure the copied strings are NUL terminated.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
> Rationale (please correct me if I'm wrong):
> 
> For a larger source string, strncpy only NUL terminates when
> the size argument is _less_ than sizeof(destination string).
> strlcpy does this when it equals sizeof (dest), but does not
> overwrite NULs in the higher chars.
> 
> Because cpumask is global I used strncpy, for the extra NULs.
> devname is local so I think strlcpy can be used.
> For {device,hwtstamp}.ifr_name I thought the strlcpy could
> be used since ifr_name is zeroed upon creation of device and
> hwtstamp.
> 
> Oh, and the parenthesis in radiotap-headers.txt should not
> be there.

See http://markmail.org/message/5ckmbipstgslzolf

(To David Wagner: this was what you meant.)

I forgot strlcpy is not present in old glibc versions,
please use this one instead.

Roel

 Documentation/accounting/getdelays.c               |    2 +-
 Documentation/hwmon/hpfall.c                       |    2 +-
 Documentation/networking/radiotap-headers.txt      |    2 +-
 .../networking/timestamping/timestamping.c         |    4 ++--
 4 files changed, 5 insertions(+), 5 deletions(-)

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
index 681ec22..fbcb585 100644
--- a/Documentation/hwmon/hpfall.c
+++ b/Documentation/hwmon/hpfall.c
@@ -27,7 +27,7 @@ int set_unload_heads_path(char *device)
 
 	if (strlen(device) <= 5 || strncmp(device, "/dev/", 5) != 0)
 		return -EINVAL;
-	strncpy(devname, device + 5, sizeof(devname));
+	strncpy(devname, device + 5, sizeof(devname) - 1);
 
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
index a7936fe..bec1f9c 100644
--- a/Documentation/networking/timestamping/timestamping.c
+++ b/Documentation/networking/timestamping/timestamping.c
@@ -374,12 +374,12 @@ int main(int argc, char **argv)
 		bail("socket");
 
 	memset(&device, 0, sizeof(device));
-	strncpy(device.ifr_name, interface, sizeof(device.ifr_name));
+	strncpy(device.ifr_name, interface, sizeof(device.ifr_name) - 1);
 	if (ioctl(sock, SIOCGIFADDR, &device) < 0)
 		bail("getting interface IP address");
 
 	memset(&hwtstamp, 0, sizeof(hwtstamp));
-	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name));
+	strncpy(hwtstamp.ifr_name, interface, sizeof(hwtstamp.ifr_name) - 1);
 	hwtstamp.ifr_data = (void *)&hwconfig;
 	memset(&hwconfig, 0, sizeof(hwconfig));
 	hwconfig.tx_type =
