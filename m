Return-Path: <linux-kernel-owner+w=401wt.eu-S1759442AbZCPT13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759442AbZCPT13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 15:27:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756739AbZCPT1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 15:27:19 -0400
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.206.146]:41709 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756478AbZCPT1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 15:27:18 -0400
X-Yahoo-Newman-Id: 254521.96230.bm@omp418.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Bkrv8UqzCbNyJrZXEDiMinT9k7TRgH2+OPMjT3BuKIVhzxb/6NJybD4S20FtU52F13CD6WXfKZ6LL4m6dGJO+BjLmK+wAFaddp8BB8o6EYHcf/BE9SMlMjrY4AZ3AhAUDn6cp7C/RPnCbSa/6fN59R72lnRqNfFfpzak00UpLV8=  ;
X-YMail-OSG: w0IjaBIVM1nEYNvEjmA0fh7a4b0I1urcAVBlj6.AN4YfAlPBtgOj37q1kunwCyRj._OqEoRcgQ4VNOudbsLfYqzJujRiFS8kPLxt2lGaceByyfpN773ZA9K2S1rMpipLvN4D8ULurZ4HaYCGlEfn8U6Q
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH v2] memory_accessor: new interface for reading/writing persistent memory
Date: Mon, 16 Mar 2009 12:27:01 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <1236478048-11075-1-git-send-email-khilman@deeprootsystems.com>
In-Reply-To: <1236478048-11075-1-git-send-email-khilman@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903161227.01938.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was kind of hoping you'd address the locking and chunking 
comments I made ... I'll ack if it includes something like
the appended patch.

---
 drivers/misc/eeprom/at24.c |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

--- a/drivers/misc/eeprom/at24.c
+++ b/drivers/misc/eeprom/at24.c
@@ -226,14 +226,11 @@ static ssize_t at24_eeprom_read(struct a
 		return status;
 }
 
-static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_read(struct at24_data *at24,
 		char *buf, loff_t off, size_t count)
 {
-	struct at24_data *at24;
 	ssize_t retval = 0;
 
-	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
-
 	if (unlikely(!count))
 		return count;
 
@@ -263,6 +260,15 @@ static ssize_t at24_bin_read(struct kobj
 	return retval;
 }
 
+static ssize_t at24_bin_read(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct at24_data *at24;
+
+	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	return at24_read(at24, buf, off, count);
+}
+
 
 /*
  * Note that if the hardware write-protect pin is pulled high, the whole
@@ -341,14 +347,11 @@ static ssize_t at24_eeprom_write(struct 
 	return -ETIMEDOUT;
 }
 
-static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+static ssize_t at24_write(struct at24_data *at24,
 		char *buf, loff_t off, size_t count)
 {
-	struct at24_data *at24;
 	ssize_t retval = 0;
 
-	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
-
 	if (unlikely(!count))
 		return count;
 
@@ -378,6 +381,15 @@ static ssize_t at24_bin_write(struct kob
 	return retval;
 }
 
+static ssize_t at24_bin_write(struct kobject *kobj, struct bin_attribute *attr,
+		char *buf, loff_t off, size_t count)
+{
+	struct at24_data *at24;
+
+	at24 = dev_get_drvdata(container_of(kobj, struct device, kobj));
+	return at24_write(at24, buf, off, count);
+}
+
 /*-------------------------------------------------------------------------*/
 
 /*
@@ -386,20 +398,20 @@ static ssize_t at24_bin_write(struct kob
  * data generated on the manufacturing floor.
  */
 
-static ssize_t at24_read(struct memory_accessor *macc, char *buf,
+static ssize_t at24_macc_read(struct memory_accessor *macc, char *buf,
 			 off_t offset, size_t count)
 {
 	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
 
-	return at24_eeprom_read(at24, buf, offset, count);
+	return at24_read(at24, buf, offset, count);
 }
 
-static ssize_t at24_write(struct memory_accessor *macc, char *buf,
+static ssize_t at24_macc_write(struct memory_accessor *macc, char *buf,
 			  off_t offset, size_t count)
 {
 	struct at24_data *at24 = container_of(macc, struct at24_data, macc);
 
-	return at24_eeprom_write(at24, buf, offset, count);
+	return at24_write(at24, buf, offset, count);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -470,9 +482,6 @@ static int at24_probe(struct i2c_client 
 		goto err_out;
 	}
 
-	at24->macc.read = at24_read;
-	at24->macc.write = at24_write;
-
 	mutex_init(&at24->lock);
 	at24->use_smbus = use_smbus;
 	at24->chip = chip;
@@ -487,6 +496,8 @@ static int at24_probe(struct i2c_client 
 	at24->bin.read = at24_bin_read;
 	at24->bin.size = chip.byte_len;
 
+	at24->macc.read = at24_macc_read;
+
 	writable = !(chip.flags & AT24_FLAG_READONLY);
 	if (writable) {
 		if (!use_smbus || i2c_check_functionality(client->adapter,
@@ -494,6 +505,8 @@ static int at24_probe(struct i2c_client 
 
 			unsigned write_max = chip.page_size;
 
+			at24->macc.write = at24_macc_write;
+
 			at24->bin.write = at24_bin_write;
 			at24->bin.attr.mode |= S_IWUSR;
 

