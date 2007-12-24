Return-Path: <linux-kernel-owner+w=401wt.eu-S1752734AbXLXUmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734AbXLXUmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 15:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbXLXUml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 15:42:41 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:2487 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbXLXUmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 15:42:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i0TgsGdKgUkFMz4FyKxJtR2JfJQSRa1zrjUFf5GicF9N3nFpjgZviIDrXVeO0ZhJq28cIv6d1UiLF6XlkafSGjgHozYV4UgT+B/4p+q2euF6bJv4ND0SzoX/yENpmBkdzysjGI0Nwqpc9Ep6n95J46Cnwp7iQD2TU9QWTXSSAiA=
Message-ID: <af57f1ac0712241242w24397e42p320283f39e7fed37@mail.gmail.com>
Date: Mon, 24 Dec 2007 23:42:38 +0300
From: "Oleg Gvozdev" <123.oleg@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: LINUX kernel 2.6.23: bug in CIFSSMBSetEA
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

In fs/cifs/cifssmb.c, in CIFSSMBSetEA (...) function wrong counting of
var exists.

EXISTING CODE:
pSMB->DataCount = sizeof(*parm_data) + ea_value_len + name_len + 1;

MUST BE:
pSMB->DataCount = sizeof(*parm_data) + ea_value_len + name_len;

REASON:
 "sizeof(*parm_data)"  counts 1 byte from "char name[1];"

So, for example in Samba server (sources/smbd/trans2.c), we can see
wrong processing of EA, cause data sent to server is bigger on 1 byte
then it must be.

See Extra info for details

--------------------------------------------- Extra info

struct fealist *parm_data;

1707 struct fea {
1708         unsigned char EA_flags;
1709         __u8 name_len;
1710         __u16 value_len;
1711         char name[1];
1712         /* optionally followed by value */
1713 };
1714 /* flags for _FEA.fEA */
1715 #define FEA_NEEDEA         0x80 /* need EA bit */
1716
1717 struct fealist {
1718         __u32 list_len;
1719         struct fea list[1];
1720 };
