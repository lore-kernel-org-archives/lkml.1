Return-Path: <linux-kernel-owner+w=401wt.eu-S1757685AbXKIWo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685AbXKIWo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 17:44:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754313AbXKIWot
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 17:44:49 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:37691 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbXKIWot (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 17:44:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L1XVy/ph+IpulkKqeUUH3JP642STg3DGr5Ujz1q6zAOHYmzz4eSMggkdqf9fGaTZiiUhj9SZqrP0A1ni7oRqUyzuJqSsCdyBj/1Na5/IouVCC5cxNwcHrk7BWmwyldhFd8xSYuXRAZtq1KaArcCJvSfKxBhC/lsYNGB+V1j9nXQ=
Message-ID: <524f69650711091444t4d02e6d8g7dd15dbe2637d714@mail.gmail.com>
Date: Fri, 9 Nov 2007 16:44:47 -0600
From: "Steve French" <smfrench@gmail.com>
To: "Przemyslaw Wegrzyn" <czajnik@czajsoft.pl>
Subject: Re: Fw: Buffer overflow in CIFS VFS.
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, joern@logfs.org,
       linux-cifs-client@lists.samba.org
In-Reply-To: <47343DA2.90306@czajsoft.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <OFA6B04F1D.DE8E7DD9-ON8725738E.00065BC2-8625738E.00066CD4@us.ibm.com>
	 <524f69650711081812j20580247kce68334b778c73c7@mail.gmail.com>
	 <47343DA2.90306@czajsoft.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I have done an analysis of the SMB functions (56 callers of
SendReceive, 4 of SendReceive2 and 2 callers of
SendReceiveBlockingLock) and found additional changes which should
help performance, by reducing the number of expensive large buffer
allocations and also by freeing buffers back to the pool faster.   See
below.   The obvious need is to create an SendReceive-NoResponse (or
equivalent) which
frees the SMB request buffer after send, and does not copy into an smb
response buffer.  The following functions need to be changed to use
that (and also address the problem that Przemyslaw noted):

TreeDisconnect, uLogoff, Close, findClose, SetFileSize, SetFileTimes,
	(Lock and PosixLock need slightly more complicated change
	since only some of their paths can use proposed new function)

There is a longer list of functions which should be optimized to call
a SendReceiveNoResponse like function as well (but we can do this
later after 2.6.24) since we also do not parse their response SMB (it
would make buffer allocation more efficient to free the request
buffers faster and avoid a memcpy):

PosixDelFile, DelFile, Rmdir, MkDir, Rename, RenameOpenFile, Copy,
CreateSymLink, CreateHardLinkUnix, CreateHardLink, SetPosixACL,
SetFSUnixInfo (also change to small buf allocate), SetEOF, SetTimes,
SetAttrLegacy, UnixSetPerms, SetEA

Some other functions can be changed to small buffer alloc requests:
Negotiate, SetFSUnixInfo, QueryReparseLink, GetExtAttr, the 6 QFSInfos
requests, Notify


Explanatory Key for the list below:
-------------------------------------------------
SR = the function currently uses SendReceive
SR2 = uses SendReceive2()
SRB = uses SendReceiveBlockingLock
large = uses smb_init (allocates large buffer)
small = uses small_smb_init (allocates small buffer)

LR = getting a large response back from the server is common
NR = no return SMB needed to be parsed by caller, processing only
depends on value of SMB error
ID = idempotent (does not change state significantly if repeated)
L  = can be long operation (and take longer than a few seconds)
B  = operation may block indefinitely
PB = operation has variable length request size due to path name in request
IOV = needs to send iovec

		List of SMB Functions and their characteristics
		-------------------------------------------------------------
(in fs/cifs/cifssmb.c)
Negotiate	large		 LR*, ID
TreeDisconnect	small	SR 	 NR
uLogoff	  	small	SR	 NR
PosixDelFile    large	SR	 PB,NR
DelFile         large   SR	 PB,NR
RmDir		large   SR	 PB,NR
MkDir		large   SR 	 PB,NR
PosixCreate     large	SR	 PB
LegacyOpen      large	SR	 PB
Open		large	SR	 PB
Read		small	SR2	 LR, ID
Write		large	SR	 (need mixed user/kernel IOV to change) L, ID?
Write2		small	SR2	 IOV, L
Lock		small	SR/SRB   NR, B
PosixLock	small	SR/SRB	 (NR on setpath), B
Close		small	SR	 NR
Rename		large	SR	 NR, PB
RenameOpenFile	large	SR	 NR, PB
Copy		large   SR	 NR, PB
CreateSymLink	large	SR	 NR, PB
CreateHardLinkU large	SR	 NR, PB
CreateHardLink	large	SR	 NR, PB
QuerySymLink	large	SR	 LR, PB, ID
QueryReparseLk	large	SR	 LR, ID
QueryPosixACL	large	SR	 LR, PB, ID
SetPosixACL	large	SR	 NR, PB
GetExtAttr	large	SR	 LR, ID
GetCIFSACL	small	SR2	 LR, ID
QueryInformatn	large	SR	 PB, ID
QPathInfo	large	SR	 PB, ID
UnixQPathInfo	large	SR	 PB, ID
FindSingle	large	SR	 PB, LR?, ID (remove)
FindFirst	large	SR	 PB, LR
FindNext	large	SR	 PB*, LR, ID*  (resume key)
FindClose	small	SR	 NR
GetSrvInodeNum	large	SR	 PB, ID
GetDFSRefer	large	SR	 PB, LR, ID
OldQFSInfo	large	SR	 ID
QFSInfo		large	SR	 ID
QFSAttribute	large	SR	 ID
QFSDeviceInfo	large	SR	 ID
QFSUnixInfo	large	SR	 ID
SetFSUnixInfo	large	SR	 ID, NR
QFSPosixInfo	large	SR	 ID
SetEOF		large	SR	 PB, NR
SetFileSize	small	SR	 NR
SetFileTimes	small	SR	 NR
SetTimes	large	SR	 PB, NR
SetAttrLegacy	large	SR	 PB, NR
UnixSetPerms	large	SR	 PB, NR
Notify		large	SR
QueryAllEAs	large	SR	 PB, LR, ID
QueryEA		large	SR	 PB, LR, ID
SetEA		large	SR	 PB, NR

(in fs/cifs/sess.c)
SessionSetup	large	SR2	 IOV, large request, LR

(in fs/cifs/connect.c)
TreeConnect	large	SR	 PB
other uses of SendReceive* in this file are obsolete

(in fs/cifs/transport.c)
send_lock_cancel  no buffer allocate, SR  NR   function looks broken



On Nov 9, 2007 4:59 AM, Przemyslaw Wegrzyn <czajnik@czajsoft.pl> wrote:
> to use SendReceive2 in places where kvec is really needed. Also these
> functions are almost identical, maybe SendReceive should wrap
> SendReceive2 preparing kvec with a buffer pointer passed to it?
>
> Obviously it is up to you, as a maintainer. I'd prefer adding a small
> header to each buffer with the buffer size and perhaps a type, or even a
> destructor function pointer. Simple macros could be used to obtain
> buffer size, given the buffer body pointer, or to dispose the buffer.
> That would save from checking the buffer type all over the code
> explicitly, or even worse, make strange assumptions about the type of
> buffer being passed - as we can see this is error-prone. That for a
> little cost of a few additional bytes per buffer.
That might be better, although without memory pools, this would perform
much worse

>



-- 
Thanks,

Steve
