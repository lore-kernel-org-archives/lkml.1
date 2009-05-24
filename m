Return-Path: <linux-kernel-owner+w=401wt.eu-S1753357AbZEXHjO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357AbZEXHjO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 May 2009 03:39:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbZEXHjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 May 2009 03:39:00 -0400
Received: from gsrv2.l39a.com ([92.243.10.117]:40361 "EHLO mail.l39a.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751384AbZEXHi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 May 2009 03:38:59 -0400
X-Greylist: delayed 385 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 May 2009 03:38:58 EDT
Message-ID: <4A18F807.3080406@l39a.com>
Date: Sun, 24 May 2009 09:32:23 +0200
From: Gabriele Turchi <gabriele.turchi@l39a.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Asus eee-top touch screen
Content-Type: multipart/signed; protocol="application/x-pkcs7-signature"; micalg=sha1; boundary="------------ms050302090906030505050208"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a cryptographically signed message in MIME format.

--------------ms050302090906030505050208
Content-Type: multipart/mixed;
 boundary="------------040804040507020302010101"

This is a multi-part message in MIME format.
--------------040804040507020302010101
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi all.

I've done some tests to use the touch screen included in the Asus 
eee-top PC under Fedora 10/11. From the first results, the touch screen 
was detected, but only the mouse button events are generated. I've 
googled around a bit to find a solution, but found nothing.

Looking into kernel and X sources, the more viable solution for me was 
to write a little kernel module, to modify a bit the event's stream to 
make them compatible with X needs.

My module is attached, even if I fully understand that this module could 
be the worst conceived and worst written ever... :-)

To be serious: my choice was to make the less invasive solution, and 
this module appear to reach the goal: my touch screen works well now. 
Maybe mine was the wrong approach, but I've found so little 
documentation on how to make a better one. I'll obviously accept any 
useful suggestion.

I hope this could be useful.

Gabriele Turchi

P.S.: Please CC me, I'm not subscribed, and my apologies for my horrible 
English.





--------------040804040507020302010101
Content-Type: text/plain;
 name="hid-touchpack.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="hid-touchpack.c"

/*
 *  HID driver for TouchPack touchscreen
 *  (ASUS eee top touch screen)
 *
 *  Copyright (c) 2009 Gabriele Turchi - gabriele.turchi@l39a.com
 */

/*
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the Free
 * Software Foundation; either version 2 of the License, or (at your option)
 * any later version.
 */

#include <linux/device.h>
#include <linux/hid.h>
#include <linux/module.h>

#include "hid-ids.h"

static int tp_input_mapping(struct hid_device *device, struct hid_input *hi,
		struct hid_field *field, struct hid_usage *usage,
		unsigned long **bit, int *max)
{
	/* This is needed for evdev compatibility: these events are (apparently) never generated, but
         * X11 evdev driver goes mad with it.
         */

	if ( (usage->hid & HID_USAGE_PAGE) == HID_UP_DIGITIZER) {
		printk(KERN_INFO "tp_input_mapping: discard HID_UP_DIGITIZER => 0x%04X\n", usage->hid);
		return -1;
	}

	return 0;
}

static int tp_event(struct hid_device *device, struct hid_field *field, struct hid_usage *usage, __s32 value)
{
	/* "Somewere" the right axis number is changed with the wrong one.
         * Here we restore the correct values.
         */

	if ( (usage->code == 0x02) || (usage->code == 0x03) )
		usage->code -= 2;
	return 0;
}


static const struct hid_device_id tp_devices[] = {
	{ HID_USB_DEVICE( 0x1bfd, 0x1688) },
	{ }
};
MODULE_DEVICE_TABLE(hid, tp_devices);

static struct hid_driver tp_driver = {
	.name = "touchpack",
	.id_table = tp_devices,
	.input_mapping = tp_input_mapping,
	.event = tp_event,
};

static int tp_init(void)
{
	return hid_register_driver(&tp_driver);
}

static void tp_exit(void)
{
	hid_unregister_driver(&tp_driver);
}

module_init(tp_init);
module_exit(tp_exit);
MODULE_LICENSE("GPL");

HID_COMPAT_LOAD_DRIVER(touchpack);

--------------040804040507020302010101--

--------------ms050302090906030505050208
Content-Type: application/x-pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIITwDCC
BhswggQDoAMCAQICAQ8wDQYJKoZIhvcNAQEFBQAwgaExCzAJBgNVBAYTAklUMQ8wDQYDVQQI
EwZNaWxhbm8xDzANBgNVBAcTBk1pbGFubzEUMBIGA1UEChMLTDM5QSBTLnIubC4xGTAXBgNV
BAsTEE5ldHdvcmsgU2VydmljZXMxIzAhBgNVBAMTGkwzOUEgQ0EgLSBOZXR3b3JrIFNlcnZp
Y2VzMRowGAYJKoZIhvcNAQkBFgtjYUBsMzlhLmNvbTAeFw0wODExMjYyMDUwMDNaFw0xMDAy
MTkyMDUwMDNaMIGIMQswCQYDVQQGEwJJVDEPMA0GA1UECBMGTWlsYW5vMQ8wDQYDVQQHEwZN
aWxhbm8xFDASBgNVBAoTC0wzOUEgUy5yLmwuMRgwFgYDVQQDEw9HYWJyaWVsZSBUdXJjaGkx
JzAlBgkqhkiG9w0BCQEWGGdhYnJpZWxlLnR1cmNoaUBsMzlhLmNvbTCCASIwDQYJKoZIhvcN
AQEBBQADggEPADCCAQoCggEBALxyBPhEN4pw/mC4rmStsbJRu94X7u4Me/D5Mw7mRbo7Q/d6
HI8+NjPnr+SHf0Q6PSD1qnd8z3QpTBuT6OYgHxw5AoUHtF2HQTL+lVxfPzDWfG/KQPLdkRz8
RGeRWC4rwnjV4qVqWwzXpfiTFqDly/0MoE/YyZkYmz9aHyao6SX+2fWm5nA7xA8c1dHtAoeB
zZAkxzusV1M7xJzRqh7QMLUmLxXfKOrTGwfgLkgifuPGlQ3DHtYAWh5wm8hk8APuJBL6E+TX
Nwko6cFTYO1gJJLeXkBCFtAJ5PehDUvx2DLb7JRFpLrMkI0bNVUCAP8A328DtG/2bZNa1sTC
v/Z0KocCAwEAAaOCAXMwggFvMAkGA1UdEwQCMAAwEQYJYIZIAYb4QgEBBAQDAgSwMCsGCWCG
SAGG+EIBDQQeFhxUaW55Q0EgR2VuZXJhdGVkIENlcnRpZmljYXRlMB0GA1UdDgQWBBTi7lQV
2CuA9AlbEF+Ey0r7v/6kIDCBtQYDVR0jBIGtMIGqgBS0j92r9jZFDtjQ2BbiW+oNAWS2faGB
jqSBizCBiDELMAkGA1UEBhMCSVQxDzANBgNVBAgTBk1pbGFubzEPMA0GA1UEBxMGTWlsYW5v
MRQwEgYDVQQKEwtMMzlBIFMuci5sLjElMCMGA1UEAxMcTDM5QSBDZXJ0aWZpY2F0aW9uIEF1
dGhvcml0eTEaMBgGCSqGSIb3DQEJARYLY2FAbDM5YS5jb22CAQEwFgYDVR0SBA8wDYELY2FA
bDM5YS5jb20wIwYDVR0RBBwwGoEYZ2FicmllbGUudHVyY2hpQGwzOWEuY29tMA4GA1UdDwEB
/wQEAwIFoDANBgkqhkiG9w0BAQUFAAOCAgEAYLV0onQcxuikyriRJWk8G6lIdLxUqj0Mankv
FvLHQPyFLKsffLvngYYY3wXtMtdurCsZfOanu3KFCNw5MMTKJ5/TCcsLK0nXJGDSbc9psqxC
DvwLjhB17ebLuzmhgnleoTp8ivvNzxJe0zc6+xBhMvwmf4uqhf/u6Sg2LeS4ufcf9q4rMVsj
FgKY5ABy/u08PynwUAbGu3UtPGZdvmcxAbLYEN8Papt0Bm+cU9yGgLObIrhn5LV4hYkyHtWa
OS1x9wq5XZ98aT1XtkKncWD6dVgw4yPfrN1MCh9CJW08yKinSzdAPv7ngqCtiGHsCEZe2T5u
vQbuReKVPZUXw0Z6B0dG7H5CdVdu6qtlP8xe9TB5gtV3PGcQ/hEIye0weJW1FI2BN+wu2RWd
eYqPIoQogYsUsiu0s9J+RTlcLbvCKAZkWZ4kbHNSZDtSNFBF/lpjr31hcebAEzTke6vRwBSy
wf91paLA/lLh8MRby1c+j+4NJnAv9bbOk/m712rpwwPTonjzw66IblRoF29HJJ6EguzomY8Q
Bheg5viPVfXKZ5DLolryZSyutVMrdHQMoQtWowN19o3AGJT1ttq4Fp82gaYfqNKTWPT1VfhU
Eh2rHNpBloDYp1UjfvjCaZhrzit7ARqXKXvgHl9R8vT1P3FME6fR/5V81qI2SQ7vtzzTT8Qw
ggYbMIIEA6ADAgECAgEPMA0GCSqGSIb3DQEBBQUAMIGhMQswCQYDVQQGEwJJVDEPMA0GA1UE
CBMGTWlsYW5vMQ8wDQYDVQQHEwZNaWxhbm8xFDASBgNVBAoTC0wzOUEgUy5yLmwuMRkwFwYD
VQQLExBOZXR3b3JrIFNlcnZpY2VzMSMwIQYDVQQDExpMMzlBIENBIC0gTmV0d29yayBTZXJ2
aWNlczEaMBgGCSqGSIb3DQEJARYLY2FAbDM5YS5jb20wHhcNMDgxMTI2MjA1MDAzWhcNMTAw
MjE5MjA1MDAzWjCBiDELMAkGA1UEBhMCSVQxDzANBgNVBAgTBk1pbGFubzEPMA0GA1UEBxMG
TWlsYW5vMRQwEgYDVQQKEwtMMzlBIFMuci5sLjEYMBYGA1UEAxMPR2FicmllbGUgVHVyY2hp
MScwJQYJKoZIhvcNAQkBFhhnYWJyaWVsZS50dXJjaGlAbDM5YS5jb20wggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQC8cgT4RDeKcP5guK5krbGyUbveF+7uDHvw+TMO5kW6O0P3
ehyPPjYz56/kh39EOj0g9ap3fM90KUwbk+jmIB8cOQKFB7Rdh0Ey/pVcXz8w1nxvykDy3ZEc
/ERnkVguK8J41eKlalsM16X4kxag5cv9DKBP2MmZGJs/Wh8mqOkl/tn1puZwO8QPHNXR7QKH
gc2QJMc7rFdTO8Sc0aoe0DC1Ji8V3yjq0xsH4C5IIn7jxpUNwx7WAFoecJvIZPAD7iQS+hPk
1zcJKOnBU2DtYCSS3l5AQhbQCeT3oQ1L8dgy2+yURaS6zJCNGzVVAgD/AN9vA7Rv9m2TWtbE
wr/2dCqHAgMBAAGjggFzMIIBbzAJBgNVHRMEAjAAMBEGCWCGSAGG+EIBAQQEAwIEsDArBglg
hkgBhvhCAQ0EHhYcVGlueUNBIEdlbmVyYXRlZCBDZXJ0aWZpY2F0ZTAdBgNVHQ4EFgQU4u5U
FdgrgPQJWxBfhMtK+7/+pCAwgbUGA1UdIwSBrTCBqoAUtI/dq/Y2RQ7Y0NgW4lvqDQFktn2h
gY6kgYswgYgxCzAJBgNVBAYTAklUMQ8wDQYDVQQIEwZNaWxhbm8xDzANBgNVBAcTBk1pbGFu
bzEUMBIGA1UEChMLTDM5QSBTLnIubC4xJTAjBgNVBAMTHEwzOUEgQ2VydGlmaWNhdGlvbiBB
dXRob3JpdHkxGjAYBgkqhkiG9w0BCQEWC2NhQGwzOWEuY29tggEBMBYGA1UdEgQPMA2BC2Nh
QGwzOWEuY29tMCMGA1UdEQQcMBqBGGdhYnJpZWxlLnR1cmNoaUBsMzlhLmNvbTAOBgNVHQ8B
Af8EBAMCBaAwDQYJKoZIhvcNAQEFBQADggIBAGC1dKJ0HMbopMq4kSVpPBupSHS8VKo9DGp5
Lxbyx0D8hSyrH3y754GGGN8F7TLXbqwrGXzmp7tyhQjcOTDEyief0wnLCytJ1yRg0m3PabKs
Qg78C44Qde3my7s5oYJ5XqE6fIr7zc8SXtM3OvsQYTL8Jn+LqoX/7ukoNi3kuLn3H/auKzFb
IxYCmOQAcv7tPD8p8FAGxrt1LTxmXb5nMQGy2BDfD2qbdAZvnFPchoCzmyK4Z+S1eIWJMh7V
mjktcfcKuV2ffGk9V7ZCp3Fg+nVYMOMj36zdTAofQiVtPMiop0s3QD7+54KgrYhh7AhGXtk+
br0G7kXilT2VF8NGegdHRux+QnVXbuqrZT/MXvUweYLVdzxnEP4RCMntMHiVtRSNgTfsLtkV
nXmKjyKEKIGLFLIrtLPSfkU5XC27wigGZFmeJGxzUmQ7UjRQRf5aY699YXHmwBM05Hur0cAU
ssH/daWiwP5S4fDEW8tXPo/uDSZwL/W2zpP5u9dq6cMD06J488OuiG5UaBdvRySehILs6JmP
EAYXoOb4j1X1ymeQy6Ja8mUsrrVTK3R0DKELVqMDdfaNwBiU9bbauBafNoGmH6jSk1j09VX4
VBIdqxzaQZaA2KdVI374wmmYa84rewEalyl74B5fUfL09T9xTBOn0f+VfNaiNkkO77c800/E
MIIHfjCCBWagAwIBAgIBATANBgkqhkiG9w0BAQUFADCBiDELMAkGA1UEBhMCSVQxDzANBgNV
BAgTBk1pbGFubzEPMA0GA1UEBxMGTWlsYW5vMRQwEgYDVQQKEwtMMzlBIFMuci5sLjElMCMG
A1UEAxMcTDM5QSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEaMBgGCSqGSIb3DQEJARYLY2FA
bDM5YS5jb20wHhcNMDYwNjE2MTk1NzQ5WhcNMTYwNjEzMTk1NzQ5WjCBoTELMAkGA1UEBhMC
SVQxDzANBgNVBAgTBk1pbGFubzEPMA0GA1UEBxMGTWlsYW5vMRQwEgYDVQQKEwtMMzlBIFMu
ci5sLjEZMBcGA1UECxMQTmV0d29yayBTZXJ2aWNlczEjMCEGA1UEAxMaTDM5QSBDQSAtIE5l
dHdvcmsgU2VydmljZXMxGjAYBgkqhkiG9w0BCQEWC2NhQGwzOWEuY29tMIICIjANBgkqhkiG
9w0BAQEFAAOCAg8AMIICCgKCAgEAqw0RxtTAyBcyp7+wJXAaQUrQLVnplfSkeZCNp/o9noMO
kVwiZC+heihKEMGwGeHL/5fEB0LlKu0H1tEwYiD0Q8DxfCRnRM4eqN2JMN+j2U+beP5Jo7HL
KknXWzQxJdST9N55+YNTA4DuPZ8xPyEsz9VLz9g39aOXRKQnSN6ErY+XCzP0guR8Yg9MsrmI
F6OqsZ9/FtariqpsnZwdYNhHvgImWOFcahbS2TJmq0S1KEGEqXHLgqekg21eIdBT05DPbCBs
MF8Qnf1hOZJU2gkaTlQmuAsO7FBGgwGulb3HgVcoY4OhPVQNQ9ZVWmMIggAsW5w6qXnMe2NE
bNFFnFRsUIc/XDekN/oE8yBsaDMgadm8QyQ22jYJ6pZmML+oAI3UrD813XbPLO51Sx1VQ0Tw
FVK7yByHqRHT9Cf20LYKdZmYwqipdiHRS/WNuMrS1p4b2r+gJ3Afq/1podLH46cYUoEyfADl
mge5Ivv8KBlMnblNFtDnQg392aqwJfH61z6vo8HKw0uuXp3GYI6PscIClGeKuFQvo+bmeX4f
+d4+nsojkTJmyyBKeykY4GwY2Kd+o3qHL/7sLfGhRShh7640PhhbbLfOJwJQP5emr+AkRU7E
KZlvy17u1rxT3+IZ1dw5zbBNRlzSJT3AyoXV0NMJourN6CB1X6TgEYKBjZ/5CHcCAwEAAaOC
AdYwggHSMB0GA1UdDgQWBBS0j92r9jZFDtjQ2BbiW+oNAWS2fTCBvQYDVR0jBIG1MIGygBRo
7L5byARXiSJ6ymK8nDPhVmqbaKGBjqSBizCBiDELMAkGA1UEBhMCSVQxDzANBgNVBAgTBk1p
bGFubzEPMA0GA1UEBxMGTWlsYW5vMRQwEgYDVQQKEwtMMzlBIFMuci5sLjElMCMGA1UEAxMc
TDM5QSBDZXJ0aWZpY2F0aW9uIEF1dGhvcml0eTEaMBgGCSqGSIb3DQEJARYLY2FAbDM5YS5j
b22CCQCaZuS1ORKmYTAPBgNVHRMBAf8EBTADAQH/MBEGCWCGSAGG+EIBAQQEAwIBBjAWBgNV
HRIEDzANgQtjYUBsMzlhLmNvbTArBglghkgBhvhCAQ0EHhYcVGlueUNBIEdlbmVyYXRlZCBD
ZXJ0aWZpY2F0ZTAtBglghkgBhvhCAQQEIBYeaHR0cDovL3d3dy5sMzlhLmNvbS9jYS1jcmwu
cGVtMDEGCWCGSAGG+EIBCAQkFiJodHRwOi8vd3d3LmwzOWEuY29tL2NhLXBvbGljeS5odG1s
MBYGA1UdEQQPMA2BC2NhQGwzOWEuY29tMA4GA1UdDwEB/wQEAwIBBjANBgkqhkiG9w0BAQUF
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
--------------ms050302090906030505050208--
