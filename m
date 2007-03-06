Return-Path: <linux-kernel-owner+w=401wt.eu-S965520AbXCFSKR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965520AbXCFSKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:10:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965493AbXCFSKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:10:17 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:43228 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535AbXCFSKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:10:14 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch v2] epoll use a single inode ...
Date: Tue, 6 Mar 2007 19:10:13 +0100
User-Agent: KMail/1.9.5
Cc: "H. Peter Anvin" <hpa@zytor.com>, Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0703051532590.4907@alien.or.mcafeemobile.com> <Pine.LNX.4.64.0703060917500.5963@woody.linux-foundation.org> <200703061828.00253.dada1@cosmosbay.com>
In-Reply-To: <200703061828.00253.dada1@cosmosbay.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_F6a7Fh/0qo9D9tM"
Message-Id: <200703061910.13431.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_F6a7Fh/0qo9D9tM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tuesday 06 March 2007 18:28, Eric Dumazet wrote:
> On Tuesday 06 March 2007 18:19, Linus Torvalds wrote:
>
> > > Using reciprocal divides permits to change each divide by two
> > > multiplies, less expensive on current CPUS.
> >
> > Are you sure?
>
> I am going to test this, but at least on Opterons, the reciprocal divide I
> added into mm/slab.c gave me a nice speedup.
>

With attached test program (one million calls to pipe()), I got about 0.1 s of 
speedup on my 1.6 GHz Pentium(M) dell D610 machine
(3.350 s instead of 3.450 s, on many runs)

Thats about 100 ns saved per number() call

But then I realized that on ia32, gcc compilers is not very smart :

static inline u32 reciprocal_divide(u32 A, u32 R)
{
	return (u32)(((u64)A * R) >> 32); 
}

It generates two multiplies... arg...

//begin of reciprocal_divide()
     4b0:       8b 4c 24 28             mov    0x28(%esp),%ecx
     4b4:       89 f0                   mov    %esi,%eax
     4b6:       f7 64 24 24             mull   0x24(%esp)
     4ba:       0f af ce                imul   %esi,%ecx
     4bd:       8d 14 11                lea    (%ecx,%edx,1),%edx
// end of reciprocal_divide()
     4c0:       8b 8c 24 8c 00 00 00    mov    0x8c(%esp),%ecx
     4c7:       89 d0                   mov    %edx,%eax
     4c9:       0f af c8                imul   %eax,%ecx
     4cc:       29 ce                   sub    %ecx,%esi
     4ce:       8b 4c 24 1c             mov    0x1c(%esp),%ecx
     4d2:       0f b6 34 31             movzbl (%ecx,%esi,1),%esi
     4d6:       89 f1                   mov    %esi,%ecx
     4d8:       89 c6                   mov    %eax,%esi
     4da:       88 0f                   mov    %cl,(%edi)
     4dc:       47                      inc    %edi
     4dd:       ff 44 24 20             incl   0x20(%esp)
     4e1:       85 c0                   test   %eax,%eax
     4e3:       75 cb                   jne    4b0 <number+0x160>

So even with a total of 3 multiplies per digit, we win...

Maybe some bit of x86 asm is needed to make gcc be smarter (using only one 
multiply for  reciprocal_divide())


--Boundary-00=_F6a7Fh/0qo9D9tM
Content-Type: text/plain;
  charset="iso-8859-1";
  name="pipes.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="pipes.c"

/*
 * micro benchmark to time calls to pipe()/close()
 */
main()
{
	int fd[100*2];
	unsigned int l, i;

	for (l = 0 ; l < 10000 ; l++) {
		for (i = 0 ; i < 100*2 ; i+=2)
			pipe(fd + i);
		for (i = 0 ; i < 100*2 ; i++)
			close(fd[i]);
	}
}

--Boundary-00=_F6a7Fh/0qo9D9tM--
