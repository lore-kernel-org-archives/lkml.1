Return-Path: <linux-kernel-owner+w=401wt.eu-S1756815AbYJMIcG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756815AbYJMIcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 04:32:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755166AbYJMIbw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 04:31:52 -0400
Received: from ns0.motion-twin.com ([213.186.50.39]:46450 "EHLO
	mail.motion-twin.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754724AbYJMIbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 04:31:51 -0400
Message-ID: <48F30772.7040207@motion-twin.com>
Date: Mon, 13 Oct 2008 10:31:46 +0200
From: Nicolas Cannasse <ncannasse@motion-twin.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Stephen Hemminger <shemminger@vyatta.com>
CC: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: recv() hangs until SIGCHLD ?
References: <48EF58D9.6060401@motion-twin.com> <20081010211700.58e953a2@speedy> <48F063C5.3000707@motion-twin.com>
In-Reply-To: <48F063C5.3000707@motion-twin.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> If there is data and the thread didn't wake up then that is a libc or 
>> kernel problem;
>> but if there is no data, then look for cases where earlier interrupted 
>> io actually
>> consumed the data already or blame the sending process not the receiver.
>> Also are the sockets blocking or non-blocking?
> 
> The sockets are non-blocking.

Sorry, I made a spelling mistake here.

I wanted to tell that the sockets ARE blocking (default behavior).

> In a practical case, we have a thread blocked in recv() for more than 12 
> hours, which is way beyond the timeout of the sender connection. The 
> socket has already been closed by the sender so recv() should at least 
> be noticed and returns 0.

To provide more informations :

Doing a lsof on the receiver, we can see that it has several ESTABLISHED 
sockets connected to a given host/sender. Doing a lsof on the host does 
not give any socket connected to the receiver (since they have been 
closed due to a timeout).

Also, the application correctly handles 0.
The pseudo-code is the following :

loop:
ret = recv()
if( ret == -1 ) {
    if( errno == EINTR ) goto loop;
    return -1;
}
return ret;

Then, on the higher level, in case we get an error ( ret <= 0 ) then we 
close the socket.

At first, we were using the libmysqlclient but since we had the bug with 
it we rewrote a mysql client so we can more easily check what's 
occurring. The same bug seems to occur with both implementations.

Best,
Nicolas
