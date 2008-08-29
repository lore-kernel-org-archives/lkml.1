Return-Path: <linux-kernel-owner+w=401wt.eu-S1754155AbYH2JNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155AbYH2JNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 05:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752361AbYH2JNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 05:13:08 -0400
Received: from aglcosbs05.cos.agilent.com ([192.25.218.36]:56978 "EHLO
	aglcosbs05.cos.agilent.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752091AbYH2JNG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 05:13:06 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 03:13:04 -0600
Message-ID: <7D8F552F9FFBAC438A816966BEC4516BFBA3D0@cos-us-mb07.cos.agilent.com>
In-Reply-To: <200808291034.09307.oliver@neukum.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: add USB test and measurement class driver - round 2
Thread-Index: AckJsdlZud+YZsLkSF+S/YZyt9wC2wAA2J9A
References: <20080827183615.GA15692@kroah.com> <200808290946.37898.oliver@neukum.org> <7D8F552F9FFBAC438A816966BEC4516BFBA389@cos-us-mb07.cos.agilent.com> <200808291034.09307.oliver@neukum.org>
From: <stefan_kopp@agilent.com>
To: <oliver@neukum.org>
Cc: <korgull@home.nl>, <greg@kroah.com>, <stern@rowland.harvard.edu>,
       <linux-usb@vger.kernel.org>, <me@felipebalbi.com>,
       <linux-kernel@vger.kernel.org>, <stefan_kopp@agilent.com>
X-OriginalArrivalTime: 29 Aug 2008 09:13:05.0159 (UTC) FILETIME=[71E9E970:01C909B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I may be misinterpreting your message, but read(2) does return the number of bytes read, so if you ask for plenty of data, you can be sure you will get less than that. A device's response should only appear in the output buffer when it is complete. I have never seen a partial response being made available by an instrument.

USBTMC instruments are mostly controlled by short commands such as "CONF:FREQ 1.3E3\n", and they usually return short strings such as a measurement result or setting, again as a human-readable string (according to a standard called "SCPI"). It is common practice to ask for, let's say, 1000 bytes, what you really expect is maybe 10...30 bytes. And you can activate the term char handling if the device supports it.

For large amounts of data (e.g. when downloading a waveform), USBTMC instruments often use a "binblock", a concept taken from the good old GPIB (IEEE488) standard, where the data is preceeded by a header and the header indicates how many bytes are following. So you first read and interpret the header and then you know exactly how many bytes to expect in the body of the message.

Best regards,
Stefan

-----Original Message-----
From: Oliver Neukum [mailto:oliver@neukum.org] 
Sent: Freitag, 29. August 2008 10:34
To: KOPP,STEFAN (A-Germany,ex1)
Cc: korgull@home.nl; greg@kroah.com; stern@rowland.harvard.edu; linux-usb@vger.kernel.org; me@felipebalbi.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2

Am Freitag 29 August 2008 10:14:46 schrieb stefan_kopp@agilent.com:
> USBTMC has a different concept, the "termination character". If this is enabled and set to the appropriate character (usually /n), the read operation will be terminated by the device automatically. The last character in the response will be the termination character. Note, however, this capability is optional (not every vendor supports it) and even if it is supported, is might be deactivated (for good reason, e.g. for transfer of binary data).
> 
> If you are not using the termination character, the device will typically send its full output buffer contents. Usually, this works just fine because communication with the device is transactional, one query followed by a response, then another query, followed by another response, and so on.
> 
> The driver does return the number of characters received in both cases (with or without use of the term character feature).

But how do you learn in user space how many characters the device actually did send? Using read() you'll only learn that the answer was shorter than you asked for. If you get the amount you expected the answer may have been as long as you expected or longer. How do you find out whether the answer was longer?

	Regards
		Oliver


