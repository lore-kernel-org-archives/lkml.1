Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179Ab0AEMto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab0AEMto (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 07:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520Ab0AEMto
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 07:49:44 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:61115 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab0AEMtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 07:49:43 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: strict copy_from_user checks issues?
Date: Tue, 5 Jan 2010 13:47:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20100104154345.GA5671@osiris.boeblingen.de.ibm.com> <20100104174308.0790757c@infradead.org> <20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100105094857.GB5480@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001051347.21309.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19Ln1x9VKWCLeToS5wUoJ2+2UBXco+KWNrA4o7
 maTT0gok5GM/tpsLKXwICmqAbLKcC26Tyk6OgK7dGK8J2mNsTq
 +BDu7h4M2swilK3p0L5JA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 January 2010, Heiko Carstens wrote:
> On Mon, Jan 04, 2010 at 05:43:08PM -0800, Arjan van de Ven wrote:
> > On Mon, 4 Jan 2010 16:43:45 +0100
> > Heiko Carstens <heiko.carstens@de.ibm.com> wrote:
> > > x86 and sparc return -EFAULT in copy_from_user instead of the number
> > > of not copied bytes as it should in case of a detected buffer
> > > overflow. That might have unwanted side effects. I would guess that
> > > is a bug.
> > 
> > killing the bad guy in case of a real buffer overflow is appropriate..
> > this should never trigger for legitimate users.
> 
> The point I tried to make is that no caller of copy_from_user can assume
> that it would ever return -EFAULT. And if any caller does so it is broken.
> But then again it probably doesn't matter in this case as long as something
> != 0 is returned.

To quote simple_read_from_buffer():

        size_t ret;
	...
        ret = copy_to_user(to, from + pos, count);
        if (ret == count)
                return -EFAULT;
        count -= ret;
        *ppos = pos + count;
        return count;

If copy_from_user() returns a negative value, bad things happen to f_pos
and to the value returned from the syscall. Many read() file_operations
do this similarly, and I wouldn't be surprised if this could be turned
into a security exploit for one of them (not simple_read_from_buffer
probably).

	Arnd
