Return-Path: <linux-kernel-owner+w=401wt.eu-S1756503AbYIDTlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbYIDTlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 15:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYIDTlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 15:41:04 -0400
Received: from styx.suse.cz ([82.119.242.94]:60402 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753113AbYIDTlB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 15:41:01 -0400
Date: Thu, 4 Sep 2008 13:40:58 -0600
From: Michal Hocko <mstsxfx@gmail.com>
To: power@bughost.org
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>, arjan@linux.intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: Why is /sys/class/power_supply/CMB1/energy_now not exported?
Message-ID: <20080904194058.GA24955@dhcp35.suse.cz>
References: <20080721041213.GA3491@dhcp35.suse.cz> <48841AE3.3000004@suse.de> <20080721165921.GB3491@dhcp35.suse.cz> <4884F98F.4060903@suse.de> <20080722030412.GA5969@dhcp35.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="y0ulUmNC+osPPQO6"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080722030412.GA5969@dhcp35.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y0ulUmNC+osPPQO6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 21, 2008 at 09:04:13PM -0600, Michal Hocko wrote:
> [fixing bad linux kernel mailing list email address - sorry, but gmail's
> thrown mailing delivery error to the spam]
> 
> On Tue, Jul 22, 2008 at 01:03:11AM +0400, Alexey Starikovskiy wrote:
> > Hi Michal,
> 
> Hi Alexey,
> 
> >
> > the charge_now part of your patch seems to be correct, but the
> > calculation is somehow broken --
> 
> I have made some experiments and the result is quite surprising to me.
> It seems that this problem is somehow related to Debian distribution
> kernel, because I wasn't able to reproduce it with the Vanilla kernel (I
> had to screw something up last time when I have checked that and
> reported in the original message).
> 
> I have tried 3 configurations:
> * 2.6.25 - Vanilla kernel with config-2.6.25 config and result output in
>   powertop-2.6.25-good
> * 2.6.25-2 - Debian distribution kernel with config-2.6.25-2 config and
>   powertop-2.6.25-2-bad output
> * 2.6.26 - Vanilla kernel with config-2.6.26 config and result output in
>   powertop-2.6.26-good
[...]

I had some time to get back to this issue and the problem why I have
seen different behavior on distribution and vanilla kernel was in
configuration. 
While distribution kernel doesn't use CONFIG_ACPI_PROCFS_POWER=y while
my vanilla kernel configuration does! This means that the patched code
wasn't triggered in my vanilla kernel testing.

So that I have checked the print_batter_sysfs again and it seems that
the problem is on another place:
powertop.c:648
	sprintf(filename, "/sys/class/power_supply/%s/current_now", dirent->d_name);
	file = fopen(filename, "r");
	if (!file)
		continue;
	memset(line, 0, 1024);
	if (fgets(line, 1024, file) != NULL) {
		watts_drawn = strtoull(line, NULL, 10) / 1000000.0;
	}
	fclose(file);

	if (!dontcount) {
		rate += watts_drawn + voltage * amperes_drawn;
	}

current rate (later used for the remaining time calculation:
display.c:201
	sprintf(buffer, _("Power usage (ACPI estimate): %3.1fW (%3.1f hours)"), rate, cap/rate);
)

is calculated as watts_drawn + voltage which is not correct, because
current_* values are in A and not in W (according to
linux-src/Documentation/power/power_supply_class.txt).

Updated patch is attached. This one is already working for me.

-- 
Michal Hocko

--y0ulUmNC+osPPQO6
Content-Type: text/x-diff; charset=iso-8859-2
Content-Disposition: attachment; filename="charge-read.patch"
Content-Transfer-Encoding: 8bit

From: mstsxfx@gmail.com
Subject: [PATCH] use charge_now when energy_now is not present

Some batteries (like one in the Futjitsu Siemens Lifebook S71110) don't
export energy_now attribute and exports only change_now in the power_supply
sys directory. 
However, we can use this value when it is multiplied by current voltage.

In addition, /sys/class/power_supply/*/current_* are in µA according to the
linux-src/Documentation/power/power_supply_class.txt and not in µW as
expected by the original code

Signed-off-by: Michal Hocko <mstsxfx@gmail.com>

Index: powertop/powertop.c
===================================================================
--- powertop.orig/powertop.c	2008-09-01 14:19:21.000000000 -0600
+++ powertop/powertop.c	2008-09-01 14:27:07.000000000 -0600
@@ -630,12 +630,19 @@ void print_battery_sysfs(void)
 
 		sprintf(filename, "/sys/class/power_supply/%s/energy_now", dirent->d_name);
 		file = fopen(filename, "r");
-		if (!file)
-			continue;
-		memset(line, 0, 1024);
-		if (fgets(line, 1024, file) != NULL) {
-			watts_left = strtoull(line, NULL, 10) / 1000000.0;
+		watts_left = 1;
+		if (!file) {
+			sprintf(filename, "/sys/class/power_supply/%s/charge_now", dirent->d_name);
+			file = fopen(filename, "r");
+			if (!file) 
+				continue;
+
+			/* W = A * V */
+			watts_left = voltage;
 		}
+		memset(line, 0, 1024);
+		if (fgets(line, 1024, file) != NULL) 
+			watts_left *= strtoull(line, NULL, 10) / 1000000.0;
 		fclose(file);
 
 		sprintf(filename, "/sys/class/power_supply/%s/current_now", dirent->d_name);
@@ -644,7 +651,7 @@ void print_battery_sysfs(void)
 			continue;
 		memset(line, 0, 1024);
 		if (fgets(line, 1024, file) != NULL) {
-			watts_drawn = strtoull(line, NULL, 10) / 1000000.0;
+			amperes_drawn = strtoull(line, NULL, 10) / 1000000.0;
 		}
 		fclose(file);
 	

--y0ulUmNC+osPPQO6--
