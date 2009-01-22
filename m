Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbZAVMzT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbZAVMzT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 07:55:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754244AbZAVMzF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 07:55:05 -0500
Received: from ppsw-7.csi.cam.ac.uk ([131.111.8.137]:55830 "EHLO
	ppsw-7.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351AbZAVMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 07:55:03 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <49786CA6.8010303@cam.ac.uk>
Date: Thu, 22 Jan 2009 12:55:02 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>, Jean Delvare <khali@linux-fr.org>,
       Ben Dooks <ben-linux@fluff.org>, David Brownell <david-b@pacbell.net>,
       spi-devel-general@lists.sourceforge.net
Subject: Re: RFC: Working around dynamic device allocation in i2c.  Interaction
 with other subystems.
References: <4974D20F.20209@cam.ac.uk>
In-Reply-To: <4974D20F.20209@cam.ac.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added spi mailing list (+ likely interested people) as the same approach
is used for device registration as with i2c. 

> Dear All,
> 
> Within board configuration files, i2c devices are currently allocated using
> i2c_board_info structures.  The only element of these that retains it's
> memory address once the struct device elements are allocated (upon adapter
> initialization) is the platform data pointer.
> 
> Several subsystems (regulator and clock for example) use an association
> method based upon a device specific string associated with a pointer to
> a device structure.  Unfortunately as things currently stand there is no
> means of obtaining a suitable device for i2c devices at the point when
> it is required (in the board config).
> 
> So the question is, how to overcome this problem?
> 
> Options that I can come up with are:
> 
> 1) Relax the constraints that the token used for device identification
>    in subsystems using the regulators approach to a void * and use
>    the platform data pointer of an i2c device.  Note this requires
>    every device which may need a regulator to have platform data.
>    Whilst this would work, it is far from ideal.
As Mark Brown pointed out:
This would also remove the ability of the APIs using this to use the
struct device for other things like showing what they're doing in sysfs
or use dev_printk.
> 
> 2) Allow more static allocation of struct i2c_client.  The way of doing
>    this with minimal disruption would be to add a pointer to i2c_board_info
>    to a preallocated i2c_client structure and if this is supplied do not
>    allocate another.  A flag can then be used to indicated whether the
>    structure has been statically allocated or not (thus preventing it
>    being inadvertently freed.
> 
> 3) Allow static allocation of i2c_client structures as a direct alternative
>    to having any i2c_board_info structures at all.  As the majority if not
>    all of i2c_board_info's elements are simply copied into the i2c_client
>    structure anyway, there is considerable overhead in option 2.  Clearly
>    it would not be simple or necessarily advisable to remove i2c_board_info
>    structures so I would propose providing an alternative set of registration
>    functions which would only be used when people cared about the problem
>    we are addressing here.
> 
> What do people think? In particular can anyone come up with any other /
> better way round this issue. (or am I missing something?)
> In particular, are there any similar cases already in kernel that would
> suggest a particular approach to solving this issue?
> 
> I have an implementation of option 2 that works fine and is relatively simple.
> 
> Thanks,
> 
> ---
> Jonathan Cameron
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

