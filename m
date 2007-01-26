Return-Path: <linux-kernel-owner+w=401wt.eu-S1030642AbXAZRHd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030642AbXAZRHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 12:07:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030764AbXAZRHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 12:07:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:33058 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030761AbXAZRHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 12:07:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=m0uLghAfPm8NRoJCM8Yis2P5Gryqkg2fy691QiyNYNOTBRJWPK/Qq86A2zIi09sL+dPXiV7BkteI0FEsZ7XkOfirGTOQtxfTgml+uoqODKAaOmU2yuE1SAbNT7u4p/BjNFSTBdNH3EpjKyItN8RHtp109wt04NcwkTIHmM54T+M=
Message-ID: <a4e6962a0701260907j786215adl9b4dbf1927c0195f@mail.gmail.com>
Date: Fri, 26 Jan 2007 11:07:28 -0600
From: "Eric Van Hensbergen" <ericvh@gmail.com>
To: "Eric Van Hensbergen" <ericvh@hera.kernel.org>
Subject: Re: [RFC][PATCH] dm-cow: copy-on-write stackable target for device-mapper
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com, paurea@gmail.com
In-Reply-To: <200611271659.kARGx5qb017564@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200611271659.kARGx5qb017564@hera.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/27/06, Eric Van Hensbergen <ericvh@hera.kernel.org> wrote:
> Subject: [RFC] [PATCH] dm-cow: copy-on-write stackable target for device-mapper
>
> +
> +A simple script file is included to format WB.
> +The way it works is the standard dmsetup calls for
> +the device mapper. The arguments are
> +

There have been several requests for the "simple" script file.
Portions of its implementation are somewhat specific to our
installation (like the use of the rc shell).  I'm including it inline
here - not sure where else to put it -- perhaps in the Documentation:

#!/usr/bin/rc

tableboth ='0 devblksz cow devread 0 devwrite devbmapw 0'
devsize = `{sfdisk -s $1}

fn wipeoutdev{
        bmapsize = `{echo $devsize / 512 /2 |bc}
        echo dd 'if=/dev/zero' 'of='^$1 'count='^$bmapsize 'bs=512'
        dd 'if=/dev/zero' 'of='^$1 'count='^$bmapsize 'bs=512'
}

fn escapedev{
    echo $1|sed 's/\//\\\//g'
}


fn setcow{
        devread = `{escapedev $1}
        devwrite = `{escapedev $2}
        devbmapw = `{escapedev $3}
        tableset = `{echo $tableboth|sed -r 's/devread/'^$devread^'/'}
        tableset = `{echo $tableset|sed -r 's/devwrite/'^$devwrite^'/'}
        tableset = `{echo $tableset|sed -r 's/devbmapw/'^$devbmapw^'/'}
        devblksz = `{expr $devsize '*' 2}
        tableset = `{echo $tableset|sed -r 's/devblksz/'^$devblksz^'/'}
        echo trying to set $tableset
        echo $tableset > /tmp/tableset
        echo trying to dmsetup create $4
        dmsetup create $4 << EOF
$tableset
EOF
        dmsetup table
}

if(! ~ $#* 4){
        echo usage: newcow origdev destdev bmapdest namecow
        exit 1
}

namecow=$4
origdev=$1
wipeoutdev $2
setcow $1 $2 $3 $namecow
