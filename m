Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbZIIQx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbZIIQx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 12:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZIIQx5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 12:53:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752608AbZIIQx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 12:53:56 -0400
Date: Wed, 9 Sep 2009 12:53:52 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, samba@lists.samba.org,
       linux-cifs-client@lists.samba.org
Subject: Re: 2.6.31-rc8: CIFS with 5 seconds hiccups
Message-ID: <20090909125352.1c7b57d2@tlielax.poochiereds.net>
In-Reply-To: <alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
References: <alpine.DEB.1.10.0909041217520.7209@V090114053VZO-1>
	<20090905071052.50501826@tlielax.poochiereds.net>
	<alpine.DEB.1.10.0909091009120.28070@V090114053VZO-1>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Sep 2009 12:33:21 -0400 (EDT)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Sat, 5 Sep 2009, Jeff Layton wrote:
> 
> > It looks like it's just taking 5s for the server to respond here. Do
> > you happen to have a wire capture of one of these events? That may tell
> > us more than cifsFYI info...
> 
> I did a tcpdump and nothing stands out. Server acks the "cmd 50" and then
> waits 5 seconds before sending the data.
> 
> 16:23:34.336373 IP (tos 0x0, ttl  64, id 20616, offset 0, flags [DF], proto 6, length: 118) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 2801206064:2801206142(78) ack 468207120 win 190
> 16:23:34.336624 IP (tos 0x0, ttl 125, id 19869, offset 0, flags [DF], proto 6, length: 206) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: P 1:167(166) ack 78 win 64548
> 16:23:34.336636 IP (tos 0x0, ttl  64, id 20617, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 78:78(0) ack 167 win 190
> 16:23:34.336669 IP (tos 0x0, ttl  64, id 20618, offset 0, flags [DF], proto 6, length: 128) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: P 78:166(88) ack 167 win 190
> 16:23:34.456343 IP (tos 0x0, ttl 125, id 20045, offset 0, flags [DF], proto 6, length: 40) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . [tcp sum ok] 167:167(0) ack 166 win 64460
> 
> hiccup
> 
> 16:23:39.284930 IP (tos 0x0, ttl 125, id 27544, offset 0, flags [DF], proto 6, length: 230) dogmeat.jules.org.microsoft-ds > fawkes.jules.org.43355: . 167:357(190) ack 166 win 64460
> 16:23:39.324060 IP (tos 0x0, ttl  64, id 20619, offset 0, flags [DF], proto 6, length: 40) fawkes.jules.org.43355 > dogmeat.jules.org.microsoft-ds: . [tcp sum ok] 166:166(0) ack 357 win 190


A binary capture would probably be easier to infer something from --
we'd be able to open it up in wireshark and get a little more info
about what sort of call the client is doing.

My suspicion would be that the server needs to perform an oplock break
to another client before it can send the response. The only way I know
how to tell that is to sniff all SMB traffic on the server and watch
for oplock break calls to other clients when these stalls occur.

-- 
Jeff Layton <jlayton@redhat.com>
