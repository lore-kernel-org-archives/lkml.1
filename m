Return-Path: <linux-kernel-owner+w=401wt.eu-S1767464AbXDFAwJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767464AbXDFAwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 20:52:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767470AbXDFAwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 20:52:06 -0400
Received: from hancock.steeleye.com ([71.30.118.248]:44085 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1767464AbXDFAwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 20:52:04 -0400
Subject: Re: Oops in scsi_send_eh_cmnd 2.6.21-rc5-git6,7,10,13
From: James Bottomley <James.Bottomley@SteelEye.com>
To: David Miller <davem@davemloft.net>
Cc: aab@cichlid.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20070405.171506.125894469.davem@davemloft.net>
References: <200704052213.l35MDRRR015981@cichlid.com>
	 <20070405.153649.104035809.davem@davemloft.net>
	 <1175817739.3714.43.camel@mulgrave.il.steeleye.com>
	 <20070405.171506.125894469.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 05 Apr 2007 19:51:00 -0500
Message-Id: <1175820660.3714.48.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-04-05 at 17:15 -0700, David Miller wrote:
> This won't work I believe.
> 
> There are cases that use smaller sense buffers than the minimum
> specified by the SCSI layer.
> 
> One example is that do_sr_ioctl() stuff when the cgc passed
> in has a sense buffer.  That will only be as large as a
> "struct request_sense".
> 
> I'm pretty sure that's one of the reasons why we cons up a local sense
> buffer in this EH code.
> 
> So we could walk past the end of that and corrupt memory with
> your patch.

That should be fine ... the application copies the sense out of
scmnd->sense_buffer ... it can take as much or as little as it wants
(sense_buffer is actually a SCSI_SENSE_BUFFERSIZE array inside the
command). There was one thing I missed, which is that the sense buffer
size of the command is 252, whereas I need to set it back down to
sizeof(scmnd->sense_buffer).

This is another area where we "could do better" ... the request actually
gives us a sense buffer, but we use our own and later copy data out of
it back into the request.

James


