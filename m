Return-Path: <linux-kernel-owner+w=401wt.eu-S1759123AbYE0U20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759123AbYE0U20 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 16:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756214AbYE0U2T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 16:28:19 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3592 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbYE0U2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 16:28:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=xxM4p1jGFLNPMI+rnjFkzAptzBRqQpLYkAfBHe9ZvAUq54Ero1hsHbKhlouqgpkvw1iY13zlyAiyArnocRWeBlkdOJIZNBvpuYhNUXQrEBmSis9oCyhW+1hng3YntEYnwJKMq3s2QTj4V4vrqKuzLt++XqY74z3yVHRieHWZwJw=
Message-ID: <483C6EAE.4050401@gmail.com>
Date: Tue, 27 May 2008 22:27:26 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Aristeu Rozanski <aris@ruivo.org>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/1] Char: vt, make sysfs operations atomic
References: <1211802812-13658-1-git-send-email-jirislaby@gmail.com> <20080527194357.GA12185@cathedrallabs.org>
In-Reply-To: <20080527194357.GA12185@cathedrallabs.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2008 09:43 PM, Aristeu Rozanski wrote:
>> Hold console sem while creating/destroying sysfs files. Serialisation is
>> so far done by BKL held in tty release_dev and chrdev_open, but no other
>> locks are held in open path.
>>
>>  				tty->termios->c_iflag |= IUTF8;
>>  			else
>>  				tty->termios->c_iflag &= ~IUTF8;
>> -			release_console_sem();
>>  			vcs_make_sysfs(tty);
>> +			release_console_sem();
>>  			return ret;
>>  		}
>>  	}
>> @@ -2772,8 +2772,8 @@ static void con_close(struct tty_struct *tty, struct file *filp)
>>  		if (vc)
>>  			vc->vc_tty = NULL;
>>  		tty->driver_data = NULL;
>> -		release_console_sem();
>>  		vcs_remove_sysfs(tty);
>> +		release_console_sem();
>>  		mutex_unlock(&tty_mutex);
>>  		/*
>>  		 * tty_mutex is released, but we still hold BKL, so there is
> the reason for the code be the way it is is because vcs_{add,remove}_sysfs()
> may sleep

What's the point? To have races in the code but not sleep inside the semaphore?
