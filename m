Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYGLVmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYGLVmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 17:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYGLVmW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 17:42:22 -0400
Received: from mail.atlantis.sk ([80.94.52.35]:49829 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbYGLVmV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 17:42:21 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: pata_it821x completely broken
Date: Sat, 12 Jul 2008 23:42:10 +0200
User-Agent: KMail/1.9.9
Cc: Alan Cox <alan@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
       linux-ide@vger.kernel.org
References: <200807042153.56644.linux@rainbow-software.org> <200807112043.36772.linux@rainbow-software.org> <20080711211409.2eef4ddb@lxorguk.ukuu.org.uk>
In-Reply-To: <20080711211409.2eef4ddb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807122342.12841.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 July 2008 22:14:09 Alan Cox wrote:
> > > commenting out the error check after ata_dev_init_params() call in
> > > ata_dev_read_id() function (libata-core.c), I got at least the device
> > > name. The capacity is 0 so it doesn't work, obviously:
>
> If you don't read the ID then it wouldn't.
>
> > I captured the IDENTIFY data from the virtual device. I'm not ATA guru
> > but looking at the data, there are zeros at many places where something
> > should be. That number starting at 0x78 looks like size of the array in
> > sectors (0x4C726C or 0x4C6C72 - the array is built from 2.5GB and 6.4GB
> > drives).
>
> The Ident data for the virtual device is fairly sparse but the specs
> don't require a lot of the field are filled in and only the LBA really
> matters.

The problem is that ata_id_n_sectors() function:

static u64 ata_id_n_sectors(const u16 *id)
{
        if (ata_id_has_lba(id)) {
                if (ata_id_has_lba48(id))
                        return ata_id_u64(id, 100);
                else
                        return ata_id_u32(id, 60);
        } else {
                if (ata_id_current_chs_valid(id))
                        return ata_id_u32(id, 57);
                else
                        return id[1] * id[3] * id[6];
        }
}

fails to retrieve the LBA48 value.


This is because the ata_id_has_lba() test

#define ata_id_has_lba(id)      ((id)[49] & (1 << 9))

fails as the identify data contains only zeros at word 49 (byte 0x62). 

Another problem is that ata_id_has_lba48() would fail too - that will break 
array over 2TB (if the controller BIOS and firmware can do it).

Looks like this needs to force LBA48 with these virtual drives.

-- 
Ondrej Zary
