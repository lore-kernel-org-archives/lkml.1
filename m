Return-Path: <linux-kernel-owner+w=401wt.eu-S1753486AbXLANEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbXLANEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 08:04:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751067AbXLANEj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 08:04:39 -0500
Received: from relay1.integra.net ([204.130.255.180]:55763 "HELO
	mail.integraonline.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751053AbXLANEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 08:04:38 -0500
In-Reply-To: <20071130230435.GA12626@puku.stupidest.org>
References: <20071114070400.GA25708@puku.stupidest.org> <20071125163014.GA17922@infradead.org> <474FBA21.4070201@sgi.com> <165B249C-FE97-4B27-927B-B39DE316CB23@xfs.org> <20071130230435.GA12626@puku.stupidest.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <A3093599-2967-4969-BFFD-1328D47FAC12@xfs.org>
Cc: Timothy Shimmin <tes@sgi.com>, Christoph Hellwig <hch@infradead.org>,
       linux-xfs@oss.sgi.com, LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Stephen Lord <lord@xfs.org>
Subject: Re: [PATCH] xfs: revert to double-buffering readdir
Date: Sat, 1 Dec 2007 07:04:27 -0600
To: Chris Wedgwood <cw@f00f.org>
X-Mailer: Apple Mail (2.752.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 30, 2007, at 5:04 PM, Chris Wedgwood wrote:

> On Fri, Nov 30, 2007 at 04:36:25PM -0600, Stephen Lord wrote:
>
>> Looks like the readdir is in the bowels of the btree code when
>> filldir gets called here, there are probably locks on several
>> buffers in the btree at this point. This will only show up for large
>> directories I bet.
>
> I see it for fairly small directories.  Larger than what you can stuff
> into an inode but less than a block (I'm not checking but fairly sure
> that's the case).

I told you I did not read any code..... once a directory is out of  
the inode
and into disk blocks, there will be a lock on the buffer while the  
contents
are copied out.

>
>> Just rambling, not a single line of code was consulted in writing
>> this message.
>
> Can you explain why the offset is capped and treated in an 'odd way'
> at all?
>
> +       curr_offset = filp->f_pos;
> +       if (curr_offset == 0x7fffffff)
> +               offset = 0xffffffff;
> +       else
> +               offset = filp->f_pos;
>
> and later the offset to filldir is masked.  Is that some restriction
> in filldir?

Too long ago to remember exact reasons. The only thing I do recall is  
issues
with glibc readdir code which wanted to remember positions in a dir  
and seek
backwards. It was translating structures and could end up with more
data from the kernel than would fit in the user buffer. This may have  
something
to do with that and special values used as eof markers in the  
getdents output
and signed 32 bit arguments to lseek. In the original xfs directory  
code, the
offset of an entry was a 64 bit hash+offset value, that really  
confused things
when glibc attempted to do math on it.

I also recall that the offsets in the directory fields had different  
meanings
on different OS's. Sometimes it was the offset of the entry itself,  
sometimes it
was the offset of the next entry, that was one of the reasons for the  
translation
layer I think.

Steve

