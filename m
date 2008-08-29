Return-Path: <linux-kernel-owner+w=401wt.eu-S1757340AbYH2Qlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340AbYH2Qlq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbYH2Qlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:41:36 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:57987 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbYH2Qlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:41:35 -0400
From: Marcel Janssen <korgull@home.nl>
Reply-To: korgull@home.nl
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Fri, 29 Aug 2008 18:41:15 +0200
User-Agent: KMail/1.9.9
Cc: stefan_kopp@agilent.com, stern@rowland.harvard.edu, oliver@neukum.org,
       linux-usb@vger.kernel.org, me@felipebalbi.com,
       linux-kernel@vger.kernel.org, Marcel Janssen <marcel.janssen@admesy.nl>
References: <20080827183615.GA15692@kroah.com> <7D8F552F9FFBAC438A816966BEC4516BFBA328@cos-us-mb07.cos.agilent.com> <20080829143902.GC18136@kroah.com>
In-Reply-To: <20080829143902.GC18136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808291841.15853.korgull@home.nl>
X-Spam-Score: -0.5 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 August 2008 16:39:02 Greg KH wrote:
> > The issue with using cat on the shell level is that it uses fread
> > which has the (in this case) ugly behaviour of recalling the driver's
> > read method until the full number of characters requested has been
> > accumulated (or until zero characters are returned, indicating the end
> > of file). With USBTMC instruments, this behavour is bad because the
> > retry will not just return zero characters, it will cause a timeout
> > with the associated error condition in the device. So, to enable the
> > use of echo/cat, I added some fread handling to the driver (which
> > catches the retries). I believe this also has been removed, so I
> > assume cat/fread will not work (?).
>
> I do not know, but we do not do wierd things in the kernel just because
> of broken userspace programs.  This logic should be done in userspace,
> and programs should look at the return value of read() and handle it
> properly.  Otherwise it is a bug.

I don't think this is broken in user space. The problem is that when you issue 
a measurement command it is not known how many bytes it will return. This is 
probably due to ASCII output being very common in  T&M devices instead of raw 
data (int, float etc). The ASCII formatting is done in the device and this 
returns just a string which may or may not be terminated by the term char. 
This is of course not true for all T&M devices, but the majority works this 
way. 

I admit that the above produces a lot of overhead, but it's just a fact that 
T&M devices work this way, including ours for most of their data processing 
(not all though). 

I think the USBTMC spec is quite clear on how it should be implemented on 
messaging level. Basically when you issue  the command "*IDN?" the device 
will process this and return the device ID string. The length of this string 
is set in the TransferSize of the 12 byte header that the device returns. The 
problem when you issue a read command is that the read command does not yet 
know how much data to expect. It should issue the  REQUEST_DEV_DEP_MSG_IN 
first and set the TransferSize value high enough.
In the USBTMC_488 extension you find an example (chapter 3.3.1 page 7) that 
shows the REQUEST_DEV_DEP_MSG_IN TransferSize being set to 64 although the 
actual data being returned from the device is less (only 36 bytes).

What you do see in practice is that when someone would issue a read command 
and asking for less bytes than are available is that the user program may 
handle this as a warning telling the user that he did not request all 
available data. 

Stefan's driver works exactly the way I would expect from a users point of 
view. Whether the implementation can be improved is another issue, but the 
behaviour is correct and compliant with other usbtmc drivers on other 
platforms.

Regards,
Marcel
 


