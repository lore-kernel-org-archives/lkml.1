Return-Path: <linux-kernel-owner+w=401wt.eu-S1763499AbYBFXsv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763499AbYBFXsv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 18:48:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759909AbYBFXsi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:48:38 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:50104 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759644AbYBFXsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:48:37 -0500
Message-ID: <47AA4748.3040702@tiscali.nl>
Date: Thu, 07 Feb 2008 00:48:24 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Roland Dreier <rdreier@cisco.com>, len.brown@intel.com,
       ibm-acpi-devel@lists.sourceforge.net, linux-acpi@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [PATCH][drivers/misc/thinkpad_acpi.c] duplicate test if (level
 & TP_EC_FAN_FULLSPEED)
References: <47A78CBB.2090401@tiscali.nl> <ada8x20gykq.fsf@cisco.com> <47A79EC8.6060700@tiscali.nl> <20080205050504.GB30670@khazad-dum.debian.net> <47A81FAE.2090709@tiscali.nl> <20080206230702.GA12395@kroah.com>
In-Reply-To: <20080206230702.GA12395@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Tue, Feb 05, 2008 at 09:34:54AM +0100, Roel Kluin wrote:
>> Henrique de Moraes Holschuh wrote:
>>> On Tue, 05 Feb 2008, Roel Kluin wrote:
>>>> Roland Dreier wrote:

>>>>>  > Note the duplicate test 'if (level & TP_EC_FAN_FULLSPEED)'. should
>>>>>  > this be replaced by
>>>>>
>>>>> Actually I suspect one of the two tests should be against TP_EC_FAN_AUTO
>>>>> (based on the comment).
>>>> Thanks Roland, for your info

>>> ACK.  This needs to be sent to stable as well.  I think both 2.6.22 and
>>> 2.6.23 need this patch.
>>>
>> CC stable@kernel.org
> 
> Please send us a real copy of the patch, when it goes into Linus's tree,
> so we know what to apply, and that it is safe to do so.

It's a oneliner and the patch is from linus' tree.
---
in commit eaa7571b2d1a08873e4bdd8e6db3431df61cd9ad, a safety net for TPEC
fan control mode was added. Quoting that patch:

"The Linux ThinkPad community is not positive that all ThinkPads that do
HFSP EC fan control do implement full-speed and auto modes, some of the
earlier ones supporting HFSP might not.

If the EC ignores the AUTO or FULL-SPEED bits, it will pay attention to the
lower three bits that set the fan level. And as thinkpad-acpi was leaving
these set to zero, it would stop(!) the fan, which is Not A Good Thing.
So, as a safety net, we now make sure to also set the fan level part of the
HFSP register to speed 7 for full-speed, and a minimum of speed 4 for auto
mode."

However, in the section below the test for the FULL-SPEED bits was not added:
the AUTO bits were tested twice. This patch corrects this and ensures that
the fan level part of the  HFSP register is set to a minimum of speed 4 for
auto mode.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/drivers/misc/thinkpad_acpi.c b/drivers/misc/thinkpad_acpi.c
index cf56647..3c323fe 100644
--- a/drivers/misc/thinkpad_acpi.c
+++ b/drivers/misc/thinkpad_acpi.c
@@ -4138,7 +4138,7 @@ static int fan_set_level(int level)
 		 * or FULLSPEED mode bits and just ignore them */
 		if (level & TP_EC_FAN_FULLSPEED)
 			level |= 7;	/* safety min speed 7 */
-		else if (level & TP_EC_FAN_FULLSPEED)
+		else if (level & TP_EC_FAN_AUTO)
 			level |= 4;	/* safety min speed 4 */
 
 		if (!acpi_ec_write(fan_status_offset, level))

