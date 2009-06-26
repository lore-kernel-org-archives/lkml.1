Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbZFZJDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbZFZJDT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 05:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752868AbZFZJDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 05:03:11 -0400
Received: from mail-yx0-f203.google.com ([209.85.210.203]:62698 "EHLO
	mail-yx0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312AbZFZJDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 05:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=M8msXle9ODxhjs24nQVus/BEk450OsiSenFirytcWvDPhROx6DtT1IIdejr6Y1MStH
         Z0IuuGLVEvpRt7lFiWZUqFCRqsTIZLQ5T6AGEO2tEEw9/dB2AYmmNi4pYxfPn1I3cSl2
         85yEAUdfj+gSJT3dOBC+8HsUDsnzpsPC4YBR8=
MIME-Version: 1.0
In-Reply-To: <42a6d9690906260128q46c092aqf29aa6d6e77b9ccb@mail.gmail.com>
References: <42a6d9690906260128q46c092aqf29aa6d6e77b9ccb@mail.gmail.com>
Date: Fri, 26 Jun 2009 16:40:57 +0800
Message-ID: <42a6d9690906260140k52f16701i13ccb8874a616688@mail.gmail.com>
Subject: SG_DXFER_TO_FROM_DEV does not copy user buffer to driver buffer in 
	linux 2.6.28 and later?
From: zhou sf <sxzzsf@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Test with the following program, and dump the data buf at queuecommand
of the driver, found the data is something like:
"00 00 00 00 ff 53 4d 42 2e 00 00 00 00 80 01 c0 00 00 00 00 00 00 00
00 00 00 00 00 02 20 4a ..."
While before 2.6.28, it is "ec ec ec ec ..." as expected.


#include <string.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <scsi/sg.h>

int main(int argc, char* argv[])
{
       int fd;
       sg_io_hdr_t io_hdr;
       int ret;

       unsigned char sensebuf[32], cdb[16], outbuf[256];

       if ((argc!=2) || (fd = open(argv[1], O_RDWR)) < 0) {
               return -1;
       }

       memset(&io_hdr, 0, sizeof(sg_io_hdr_t));
       memset(cdb, 0, sizeof(cdb));
       memset(outbuf, 0xec, sizeof(outbuf));
       memset(sensebuf, 0xec, sizeof(sensebuf));

       io_hdr.interface_id = 'S';

       io_hdr.cmdp = cdb;
       io_hdr.cmd_len = sizeof(cdb);

       io_hdr.sbp = sensebuf;
       io_hdr.mx_sb_len = sizeof(sensebuf);

       io_hdr.dxferp = outbuf;
       io_hdr.dxfer_len = sizeof(outbuf);
       io_hdr.dxfer_direction = SG_DXFER_TO_FROM_DEV;

       io_hdr.timeout = 20000;

       ret = ioctl(fd, SG_IO, &io_hdr);
       return 0;
}
