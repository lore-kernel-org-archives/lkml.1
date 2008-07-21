Return-Path: <linux-kernel-owner+w=401wt.eu-S1760762AbYGUGwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760762AbYGUGwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 02:52:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbYGUGvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 02:51:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:12975 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbYGUGvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 02:51:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=DjYQW9WZ47CNb4i2RU5gOm/7ZW4p/IxXUWPnBW4D2rnhbuyVXDpX0TrVhiUL/jwYiJ
         lrUgLYeO4nJlkCLfNvw6jKzZxB1epVF26ty3hvxJGsN35JEnsbbcP6BQYQpNflla2XPw
         /GvwoHovilZpcnH+/cCx2cBsXNCT4XLq3Eiow=
Message-ID: <19f34abd0807202351w52b45bc9m6ba5133af696748b@mail.gmail.com>
Date: Mon, 21 Jul 2008 08:51:42 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Marcel Holtmann" <marcel@holtmann.org>
Subject: Re: [PATCH] Bluetooth: fix oops in rfcomm tty code (v2)
Cc: "Maxim Krasnyansky" <maxk@qualcomm.com>,
       "Dave Young" <hidave.darkstar@gmail.com>,
       "Soeren Sonnenburg" <kernel@nn7.de>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1216503500.8411.110.camel@violet.holtmann.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080719211227.GA14173@localhost.localdomain>
	 <1216503500.8411.110.camel@violet.holtmann.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 19, 2008 at 11:38 PM, Marcel Holtmann <marcel@holtmann.org> wrote:
> Hi Vegard,
>
>> This is a resend of a patch I sent earlier. It fixes a reproducible
>> oops (see http://lkml.org/lkml/2008/7/13/89 for test case), and I'd
>> be very happy for some feedback from Bluetooth people. Can this be
>> included for testing somewhere? I don't have any bluetooth devices
>> myself, so all my testing is limited to creating/releasing devices
>> with ioctl (I'm not sure that's good enough).
>>
>> Dave: I have extended the rfcomm_dev_lock to include all the setup and
>> teardown of a single device. On second thought, it doesn't really make
>> sense to use a separate lock for that. May I have your opinion on this
>> second version? (I've fixed the comments/BUG_ON that you pointed out.)
>
> it seems it is the actually the first time, I see this one. Anyway, so
> holding that lock is a bad idea. Fixing this the right way might be
> tricky since the TTY layer is involved here and own the kobject. So I
> would say we have to make sure that the RFCOMM TTY will hangup when
> calling RELEASEDEV or otherwise fail.

On Mon, Jul 21, 2008 at 7:14 AM, Marcel Holtmann <marcel@holtmann.org> wrote:
>> The patch titled
>>      Bluetooth: fix oops in rfcomm tty code
>> has been added to the -mm tree.  Its filename is
>>      bluetooth-fix-oops-in-rfcomm-tty-code-v2.patch
>>
> just a quick note that I am not okay with this patch. Holding the lock
> isn't the right solution since it would also block any other application
> from creating new devices. We can't do this.

Hi,

We are not holding the lock across any ioctl/syscall boundary, which
would be an error anyway.

The lock now additionally protects the calls to:

    tty_register_device
    tty_unregister_device
    device_create_file

I don't think these functions block or do anything with the device
apart from just registering/unregistering the files.

Can you please explain in more detail what is wrong with the patch?
Where are we preventing other applications from creating new devices?
My intention was to prevent other applications from creating the
_same_ devices while they are still in use, although attempting to
register a new device (with an already-in-use ID) should simply fail,
and not block.

Thank you,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036



-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
