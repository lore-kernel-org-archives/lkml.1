Return-Path: <linux-kernel-owner+w=401wt.eu-S1761311AbXKBRSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761311AbXKBRSq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753399AbXKBRSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:18:38 -0400
Received: from mail1.webmaster.com ([216.152.64.169]:2963 "EHLO
	mail1.webmaster.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093AbXKBRSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:18:37 -0400
From: "David Schwartz" <davids@webmaster.com>
To: "Andrew Haley" <aph@redhat.com>
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Tomash Brechko" <tomash.brechko@gmail.com>
Subject: RE: Is gcc thread-unsafe?
Date: Fri, 2 Nov 2007 10:18:10 -0700
Message-ID: <MDEHLPKNGKAHNMBLJOLKIEJIHPAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook IMO, Build 9.0.6604 (9.0.2911.0)
In-Reply-To: <e2e108260711020829p5994f79bp48ca35a1ce84ff03@mail.gmail.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Importance: Normal
X-Authenticated-Sender: joelkatz@webmaster.com
X-Spam-Processed: mail1.webmaster.com, Fri, 02 Nov 2007 10:19:08 -0700
	(not processed: message from trusted or authenticated source)
X-MDRemoteIP: 206.171.168.138
X-Return-Path: davids@webmaster.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Reply-To: davids@webmaster.com
X-MDAV-Processed: mail1.webmaster.com, Fri, 02 Nov 2007 10:19:09 -0700
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> Another conclusion from the cited text is that in contrast with what
> was stated before on the gcc mailing list, it is not required to
> declare thread-shared variables volatile if that thread-shared data is
> consistently protected by calls to locking functions.
>
> Bart Van Assche.

It all depends upon what threading standard you are using. If GCC is going
to support POSIX threading, it cannot require that thread-shared data be
marked 'volatile' since POSIX does not require this.

It can offer semantic guarantees for volatile-qualified data if it wants to.
But POSIX provides a set of guarantees that do not require marking data as
'volatile' and if GCC is going to support POSIX threading, it has to support
providing those guarantees.

As far as I know, no threading standard either requires 'volatile' or states
that it is sufficient for any particular purpose. So there seems to be no
reason to declare thread-shared variables as
volatile except as some kind of platform-specific optimization.

POSIX mutexes are sufficient. They are necessary if there is no other way to
get the guarantees you need. Nothing prevents GCC from providing any
guarantees it wants for 'volatile' qualified data. But POSIX mutexes must
work as POSIX specifies or GCC cannot support POSIX threading.

This is the nightmare scenario (thanks to Hans-J. Boehm):

int x;
bool need_to_lock;
pthread_mutex_t mutex;

for(int i=0; i<50; i++)
{
 if(unlikely(need_to_lock)) pthread_mutex_lock(&mutex);
 x++;
 if(unlikely(need_to_lock)) pthread_mutex_unlock(&mutex);
}

Now suppose the compiler optimizes this as follows:

register=x;
for(int i=0; i<50; i++)
{
 if(need_to_lock)
 {
  x=register; pthread_mutex_lock(&mutex) register=x;
 }
 register++;
 if(need_to_lock)
 {
  x=register; pthread_mutex_unlock(&mutex); register=x;
 }
}
x=register;

This is a perfectly legal optimization for single-threaded code. It may in
fact be an actual optimization. Clearly, it totally destroys threaded code.

This shows that, unfortunately, the normal assumption that not knowing
anything about the pthread functions ensures that optimizations won't break
them is incorrect.

DS


