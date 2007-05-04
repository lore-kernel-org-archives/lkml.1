Return-Path: <linux-kernel-owner+w=401wt.eu-S932812AbXEDIiU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812AbXEDIiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 04:38:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932929AbXEDIiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 04:38:19 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:55992 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932812AbXEDIiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 04:38:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=NenBWq2ow1DHtXLJu+64vEriaJ0Xpq64Z50iBg/pICd+WGlWGZdWCVYZCblwV4HU3EHhmJYKXKMk/YUgOyFrX3jiUbNuSVeMKVVIe8zohQSAz3aAEolGMSFye4L5v+26hRse/9ZMSd7dW2AFnUuKn/0l9VnneaWp7qIACGyeVEQ=
Message-ID: <5486cca80705040138r6ac16e9bp77e4f6217720ea8@mail.gmail.com>
Date: Fri, 4 May 2007 10:38:10 +0200
From: "Antonino Ingargiola" <tritemio@gmail.com>
To: linux-usb-users@lists.sourceforge.net
Subject: [SOLVED] Serial buffer corruption [was Re: FTDI usb-serial possible bug]
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 4/14/07, Antonino Ingargiola <tritemio@gmail.com> wrote:
> Hi to the list,
>
> I report a problem found with a device that use the FTDI chip to
> communicate data to pc.
>
<summary of snipped problem description>
The scenario is: a serial device streams data continuously toward the
pc. The application requires the data be read once in a while (so not
all data is read). There is a corruption reading the data (old data
mixed with the new one).

The problem is absent in windows (using the same HW device and python code).
<end summary>

I report for reference how I solved the problem.

The problem arises because (while not reading)  the input stream fills
the input buffer. Once filled, the buffer does not accept new data, so
the lost data is the new one not the old.

When one need to read the data he flushes the input buffer, but this
is not sufficient. In fact there is a second (hardware?) buffer in the
chain that, suddenly after the flush, pushes a chunk of old data in to
the input buffer. After this the new data is queued. This result in
data corruption at the edge between the new and the old data in the
buffer.

The problem has been reproduced also with an usb-serial device using
the cdc-acm driver and with two serial port linked by a null-modem
cable (so its not FTDI specific).

To solve the problem we must do a complete flush of all the buffer
chain. I do this flushing the input multiple times with a small pause
between them. In my case 10 flushes separated by a 10ms pause always
empties the whole buffer chain, so I get no corruption anymore. I'ts
not an elegant solution but it works (10 flushes are an overkill but I
want to be _really_ sure to read the correct data).

If someone know a better way to solve the problem is more than welcome
to suggest. Furthermore just a confirmation of my analysis of the
serial buffer behavior would be appreciated.

What puzzled me at first was that on windows the "flush" flushes all
the buffers, so the problem does not arises. Maybe Linux serial stack
works this way because is dictated by the POSIX standard ... I don't
know, just guessing.

Thanks,

  ~ Antonio

PS: For reference, the original report was:
http://marc.info/?l=linux-kernel&m=117683012421931&w=2
