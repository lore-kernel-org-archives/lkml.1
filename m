Return-Path: <linux-kernel-owner+w=401wt.eu-S1752688AbXBEDu5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbXBEDu5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Feb 2007 22:50:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752689AbXBEDu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Feb 2007 22:50:57 -0500
Received: from mailgw.cvut.cz ([147.32.3.235]:46454 "EHLO mailgw.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688AbXBEDu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Feb 2007 22:50:56 -0500
Message-ID: <45C6A99C.5030607@vc.cvut.cz>
Date: Sun, 04 Feb 2007 19:50:52 -0800
From: Petr Vandrovec <vandrove@vc.cvut.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.9) Gecko/20061219 Iceape/1.0.7 (Debian-1.0.7-3)
MIME-Version: 1.0
To: Pierre Ossman <drzeus-list@drzeus.cx>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: NCPFS and brittle connections
References: <459D1794.2060009@drzeus.cx> <459D38DA.4030803@vc.cvut.cz> <459D55E3.4000905@drzeus.cx> <459E01B2.50309@vc.cvut.cz> <45B77AE4.2010605@drzeus.cx> <45B79C35.2090302@vc.cvut.cz> <45B7D750.1040501@drzeus.cx> <45B868D5.9070409@vc.cvut.cz> <45B8845E.8070008@drzeus.cx> <45C57695.7000707@vc.cvut.cz> <45C61540.7000008@drzeus.cx>
In-Reply-To: <45C61540.7000008@drzeus.cx>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pierre Ossman wrote:
> Petr Vandrovec wrote:
>> Problem is with these pointers - reply_buf & server->packet.  Now code
>> will just read packet from server->packet, and write result to
>> reply_buf, most probably transmiting some random data to network, and
>> overwriting innocent memory on receiption...  I believe that you need
>> to make copies of server->packet/size for transmission, and some
>> simillar solution for receive as well.  As both request & response can
>> be up to ~66000 bytes.
> 
> Hmm.. I thought server->packet was protected until the packet was
> completed, independent of the process that issued it. Looking closer I
> see that this isn't quite the case.
> 
> How about this... We allocate two buffers at startup, one for outgoing
> and one for incoming. Then we use these during the actual transmission,
> copying back and forth as need. Then we just need to avoid the final
> response copy if the process has gone belly up.

You must not allow anybody to reuse transmit buffer until you are done 
with all retransmits and received reply from server...  That's why code 
uses same buffer for both request and reply - you never need both, and 
as maximum size is more or less same for both (65KB), it avoid problem 
that you would need two 65KB buffers in worst case.

> Now my next question in that case is, what is the purpose of
> server->packet. Couldn't this buffer be provided by the caller like the
> response buffer?

Then you would need to do vmalloc (or maybe kmalloc for some cases) on 
each request transmit & receive.  And only very few callers provide 
receive buffer - most of them does ncp_request() which receives reply to 
server->packet, without doing any additional allocation - there are only 
three callers which use ncp_request2 - two of them (ioctl, 
ncp_read_bounce) do that because copy_to_user is not allowed while 
ncp_server is locked, and third one (search for file set) does that 
because caller may need to issue additional NCP calls while parsing its 
result.  But everybody else gets away with no memory allocation.
								Petr


