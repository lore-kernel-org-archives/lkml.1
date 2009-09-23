Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800AbZIWGI6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800AbZIWGI6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:08:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbZIWGI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:08:58 -0400
Received: from mail-gw.exalead.com ([193.47.80.29]:38640 "EHLO exalead.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753092AbZIWGI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:08:57 -0400
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Wed, 23 Sep 2009 02:08:57 EDT
Message-ID: <4AB9B9B7.1020309@exalead.com>
Date: Wed, 23 Sep 2009 08:01:27 +0200
From: Xavier Roche <roche+kml2@exalead.com>
Organization: Exalead
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.8.1.22) Gecko/20090606 SeaMonkey/1.1.17
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Inter-process send()/recv() using zero-copy ?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

I was wondering if there was a way to have zero-copy send()/recv(), when 
the socket is connected to the local machine (to another process on the 
same machine, for example) ?

Such feature would be only feasible with page-aligned blocks, from an a 
mmap'ed block to another one, I guess.

Typical case:

Process #1 (uid A)
buff = mmap(0, size, ..) /* anonymous or not */
...
send(s, buff, size, 0)
munmap(buff, size)

Process #2 (uid B)
buff = mmap(0, size, .. | MAP_ANONYMOUS, ..)
recv(s, buff, size, 0)

In an ideal fantasy world, the first process would use send() to 
transmit the complete page-aligned memory block to the other side, and 
the second process would use recv() to get the memory block on a similar 
anonymously mmap'ed block, and the only operation the kernel would do 
would be to share the memory block between the two processes with 
copy-on-write.

On the real world, the same operation requires a first read of the whole 
memory block (possibly partially on disk) and a complete write (possibly 
partially on disk, too) with two copies of the same memory region at the 
end.

Two solutions can be used to emulate such feature:

1. use a temporary mmap'ed file
- but requires a temporary file
- permissions for the file ? (not necessarily from the same UID)
- special case for local network block transmissions vs. machine-to-machine

2. use shared memory explicitely
- handling of permissions ? (ditto)
- special case for local network block transmissions vs. machine-to-machine

splice() and friends do not appear to give any help for this case, and I 
was wondering if there was a chance to do that ?

