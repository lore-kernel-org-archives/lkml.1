Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbZFBTLL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbZFBTLL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 15:11:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345AbZFBTK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 15:10:58 -0400
Received: from h155.mvista.com ([63.81.120.155]:27852 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751131AbZFBTK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 15:10:57 -0400
Message-ID: <4A25798F.3030700@ru.mvista.com>
Date: Tue, 02 Jun 2009 23:12:15 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
       linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>, Frans Pop <elendil@planet.nl>
Subject: Re: [PATCH 4/4] ide: preserve Host Protected Area by default
References: <20090531143911.7164.26834.sendpatchset@localhost.localdomain> <20090531143939.7164.82399.sendpatchset@localhost.localdomain> <200906012333.29159.bzolnier@gmail.com>
In-Reply-To: <200906012333.29159.bzolnier@gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Bartlomiej Zolnierkiewicz wrote:

>>From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>Subject: [PATCH] ide: preserve Host Protected Area by default

>>From the perspective of most users of recent systems, disabling Host
>>Protected Area (HPA) can break vendor RAID formats, GPT partitions and
>>risks corrupting firmware or overwriting vendor system recovery tools.

>>Unfortunately the original (kernels < 2.6.30) behavior (unconditionally
>>disabling HPA and using full disk capacity) was introduced at the time
>>when the main use of HPA was to make the drive look small enough for the
>>BIOS to allow the system to boot with large capacity drives.

>>Thus to allow the maximum compatibility with the existing setups (using
>>HPA and partitioned with HPA disabled) we automatically disable HPA if
>>any partitions overlapping HPA are detected.  Additionally HPA can also
>>be disabled using the "nohpa" module parameter (i.e. "ide_core.nohpa=0.0"
>>to disable HPA on /dev/hda).

>>While at it:
>>- remove stale "idebus=" entry from Documentation/kernel-parameters.txt

>>Cc: Robert Hancock <hancockrwd@gmail.com>
>>Cc: Frans Pop <elendil@planet.nl>
>>Cc: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
>>Cc: Al Viro <viro@zeniv.linux.org.uk>
>>[patch description was based on input from Alan Cox and Frans Pop]
>>Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

Acked-by: Sergei Shtylyov <sshtylyov@ru.mvista.com>

> v2 interdiff

> v2:
> Fix ->resume HPA support.

> diff -u b/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
> --- b/drivers/ide/ide-disk.c
> +++ b/drivers/ide/ide-disk.c
> @@ -433,8 +433,11 @@
>  		goto out;
>  
>  	set = ide_disk_hpa_set_capacity(drive, set, lba48);
> -	if (set)
> +	if (set) {

    Well, this seems to be a useful check after all. :-)

> +		/* needed for ->resume to disable HPA */
> +		drive->dev_flags |= IDE_DFLAG_NOHPA;
>  		return set;
> +	}
>  out:
>  	return drive->capacity64;
>  }

MBR, Sergei
