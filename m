Return-Path: <linux-kernel-owner+w=401wt.eu-S1751399AbXDHQ0J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751399AbXDHQ0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 12:26:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbXDHQ0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 12:26:09 -0400
Received: from web33012.mail.mud.yahoo.com ([209.191.69.127]:41434 "HELO
	web33012.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751399AbXDHQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 12:26:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=gurKBW4cFwrRfxoZe7e2EqAoYeOHsKfjH7nupfp4vkjHjtja1IiU5hx4f0EaRzTGpCoUYaJ2pKMwHPcCU5Phb5woFRuTb88ETarmLsYmgRdLi7ESwF9zjZvf5cqwCjJQQrRgbd1XSzOnKlymngx1G7/FH4IHZGZ4op6YDH14/tw=;
X-YMail-OSG: k1.aQ3kVM1n03paNXQPw.XdlDrBO87padhiJr.u2KRY_n8ffUJCH4AgYkVmHNrl.qBVmXUy76wVUzOA4Yx8YU4cQkwoB0tM9kdJbLwWQcuwme5xgEg.WWPWMfA--
Date: Sun, 8 Apr 2007 09:26:06 -0700 (PDT)
From: Stephen Cameron <smcameron@yahoo.com>
Subject: Re: [PATCH] Perverting cciss
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, james.bottomley@steeleye.com,
       mike.miller@hp.com, steve.cameron@hp.com
In-Reply-To: <20070408101902.GA2275@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <759655.87535.qm@web33012.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Christoph Hellwig <hch@infradead.org> wrote:
 
> Also is there a reason you don't want to pass down the various
> other ioctls scsi_cmd_ioctl can handle to it?

Didn't think about it, SG_IO is the one people were
clamoring for.

SG_GET_VERSION_NUM:
easily doable.

SCSI_IOCTL_GET_IDLUN:
Hmm, cciss is a block driver, and doesn't
really have an ID/LUN which are meaningful
in the normal sense of this ioctl.  If we
report something for this one, it is going to
conflict with some other device on the system
if that info is used in the usual way.  That is,
disk devices on cciss do not have any bus/target/lun
as far as linux is concerned, and aren't addressable
using those.

SCSI_IOCTL_GET_BUS_NUMBER:
Same problem as SCSI_IOCTL_GET_IDLUN.

SG_SET_TIMEOUT:
SG_GET_TIMEOUT:
Doable.  I don't think timeout will be honored though,
and I think this has to do with the sg driver, which
isn't involved with cciss anyhow, as cciss is not
a scsi driver (except for tape drives).

SG_GET_RESERVED_SIZE:
SG_SET_RESERVED_SIZE:
I think this is an sg driver thing and won't make
any difference for cciss, but we could pass it
through, I guess.

SG_EMULATED_HOST:

Er....  I guess we can do it:

/*
 * will always return that we are ATAPI even for a real SCSI drive, I'm not
 * so sure this is worth doing anything about (why would you care??)
 */
static int sg_emulated_host(request_queue_t *q, int __user *p)
{
        return put_user(1, p);
}

What's it for?



CDROM_SEND_PACKET:
CDROMCLOSETRAY:
CDROMEJECT:

I think all the CDROM stuff doesn't really apply.  CD-ROMs
on smartarray are not supported, nor are CD-ROMs presented
even if you attach one (excepting some weird tape device
that HP sells which sometimes pretends to be a CDROM for
booting purposes.) (Why would you put a cdrom on a RAID 
controller?)  I guess we could pass it through, it might not 
hurt, probably doesn't help though, and might give people
the mistaken impression that they can connect a SCSI cd-rom 
to a smartarray.

SCSI_IOCTL_SEND_COMMAND:

Doable, I think.

It'll be tomorrow at best before I can try anything out
or fix the other stuff you pointed out though.

-- steve




 
____________________________________________________________________________________
Bored stiff? Loosen up... 
Download and play hundreds of games for free on Yahoo! Games.
http://games.yahoo.com/games/front
