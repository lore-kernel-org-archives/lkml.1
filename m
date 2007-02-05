Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXBEMN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXBEMN2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXBEMN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:13:28 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:6379 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932169AbXBEMN2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:13:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=O+FbaCxgj/9dYoJwk6wFxfWDCT+ljcc2czZRFfp8NWNoyAJ/SLiNHVVTNlQhMzF9JEnH0V56pUFC0t01epRFuAs7CkvgVAvULsGj+ARslsF9S1xdnFTw4LtQ7iiMrJSLvt7nxl9Z7W9LoGxidh5EjfqBILgateqiGDdUnCOC7L0=
Message-ID: <fb6b09f20702050413o6123b27eof07e7501e8d4a7e5@mail.gmail.com>
Date: Mon, 5 Feb 2007 07:13:26 -0500
From: "Sue Alfano" <smalfano@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: waitid() problem?
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I didn't get any responses on this.  I thought maybe the subject line
was misleading, so I'm trying a different one.  If I'm using the wrong
mailing list, or if there's another site other than kernel.org that I
should be using to search through archives and FAQs, please let me
know.

I'm accessing the waitid function in the kernel using the _syscall4
macro  since it's not supported in uClibc.  waitid worked great, but
then I started having problems when more than one child needed to be
reaped.

Basically, the parent process registers a SIGCHLD signal handler via sigaction()
with the SA_RESTART option and then sits on a timed select().  All the signal
handler does is set a flag - the waitid processing takes place when the parent
drops out of the select because of the signal or a timeout.  When the waitid
succeeds, the pid is used to do some processing and then is used to call
waitpid to clean up the mess.  This is all in a while loop, so when the waitid
is called again, 0 is returned with si_pid = 0 indicating that there are no
more children to reap.  That's all great.  The problem occurs when there's 2
or more children to reap.  When this occurs, the 2nd waitid call returns -1
and si_pid = 0.  The waitid continues to fail in this manner until the parent
receives another SIGCHLD signal, then it works for the next zombie child in
the waiting line, but only one.  I can send SIGCHLD kills to the parent from
the console and eventually get everything cleaned up.  Sending the kill from
the parent isn't enough - I suppose it wants to be blocking on the select.

I tried registering the signal handler without SA_RESRART and also via signal(),
since there was a posting about SA_RESTART, but that made no difference.  I
also tried not having a signal handler at all, but then I couldn't reap any
children on the timeout.

So, are there known issues with waitid when there are multiple children piled
up waiting to be reaped?  If so, is there a patch or a workaround?

The product that I'm working on is using Linux version 2.6.12-2.0.0-258

Thanks for any help,
Sue
