Return-Path: <linux-kernel-owner+w=401wt.eu-S1755462AbYH2IZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462AbYH2IZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 04:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbYH2IZK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 04:25:10 -0400
Received: from aglsgpbs01.sgp.agilent.com ([192.25.82.30]:42739 "EHLO
	aglsgpbs01.sgp.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbYH2IZH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 04:25:07 -0400
X-Greylist: delayed 534 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Aug 2008 04:25:06 EDT
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 02:14:46 -0600
Message-ID: <7D8F552F9FFBAC438A816966BEC4516BFBA389@cos-us-mb07.cos.agilent.com>
In-Reply-To: <200808290946.37898.oliver@neukum.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: add USB test and measurement class driver - round 2
Thread-Index: AckJqzQJRLGUZ4r2Sd+PyGOfrC6WXAAAE3aQ
References: <20080827183615.GA15692@kroah.com> <200808281858.42486.korgull@home.nl> <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com> <200808290946.37898.oliver@neukum.org>
From: <stefan_kopp@agilent.com>
To: <oliver@neukum.org>
Cc: <korgull@home.nl>, <greg@kroah.com>, <stern@rowland.harvard.edu>,
       <linux-usb@vger.kernel.org>, <me@felipebalbi.com>,
       <linux-kernel@vger.kernel.org>, <stefan_kopp@agilent.com>
X-OriginalArrivalTime: 29 Aug 2008 08:14:47.0503 (UTC) FILETIME=[4D25F5F0:01C909AF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oliver,

USBTMC has a different concept, the "termination character". If this is enabled and set to the appropriate character (usually /n), the read operation will be terminated by the device automatically. The last character in the response will be the termination character. Note, however, this capability is optional (not every vendor supports it) and even if it is supported, is might be deactivated (for good reason, e.g. for transfer of binary data).

If you are not using the termination character, the device will typically send its full output buffer contents. Usually, this works just fine because communication with the device is transactional, one query followed by a response, then another query, followed by another response, and so on.

The driver does return the number of characters received in both cases (with or without use of the term character feature).

The issue is more the habit of fread of "insisting" on receiving the full number of characters requested in the call to fread. Usually, you don't know how many characters will be returned by a USBTMC device, so you just ask for plenty and see how many you get. This works just fine with read(2). fread, unfortunately, retries the read by calling the driver's read entry point again. If you don't catch this retry and ask the USBTMC device for data, you will receive a timeout (unless there happens to be additional data in the device's output buffer).

In the original driver, I "simulated" an EOF by just returning 0 in the retry call to the read method. Not sure there's a better way of handling this issue because you can't rely on the termination character... However, I'm very open to ideas... As I said earlier, I avoided this whole issue by using read in my next layer.

Best regards
Stefan


-----Original Message-----
From: Oliver Neukum [mailto:oliver@neukum.org] 
Sent: Freitag, 29. August 2008 09:47
To: KOPP,STEFAN (A-Germany,ex1)
Cc: korgull@home.nl; greg@kroah.com; stern@rowland.harvard.edu; linux-usb@vger.kernel.org; me@felipebalbi.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2

Am Freitag 29 August 2008 08:57:54 schrieb stefan_kopp@agilent.com:
> The issue with using cat on the shell level is that it uses fread 
> which has the (in this case) ugly behaviour of recalling the driver's 
> read method until the full number of characters requested has been 
> accumulated (or until zero characters are returned, indicating the end 
> of file). With USBTMC instruments, this behavour is bad because the 
> retry

This may be problematic. The driver is throwing away EOF in other words.
Generally this is not a good idea. User space can no longer tell how long the reply was.

	Regards
		Oliver



