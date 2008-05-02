Return-Path: <linux-kernel-owner+w=401wt.eu-S932920AbYEBONX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbYEBONX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 10:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756815AbYEBONP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 10:13:15 -0400
Received: from mx1.redhat.com ([66.187.233.31]:43571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbYEBONO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 10:13:14 -0400
Date: Fri, 2 May 2008 10:11:32 -0400
From: Jakub Jelinek <jakub@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Alistair John Strachan <alistair@devzero.co.uk>,
       Chris Knadle <Chris.Knadle@coredump.us>,
       Andrew Morton <akpm@linux-foundation.org>,
       Adrian Bunk <bunk@kernel.org>, venkatesh.pallipadi@intel.com,
       davem@davemloft.net, trini@kernel.crashing.org, mingo@elte.hu,
       tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org,
       suresh.b.siddha@intel.com,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: huge gcc 4.1.{0,1} __weak problem
Message-ID: <20080502141132.GN2255@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20080501235558.GA20637@orac.ofobscurity.com> <200805021055.10602.alistair@devzero.co.uk> <20080502104348.GC20741@uranus.ravnborg.org> <200805021248.56797.alistair@devzero.co.uk> <20080502135708.GA22929@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080502135708.GA22929@uranus.ravnborg.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 03:57:08PM +0200, Sam Ravnborg wrote:
> OK, can anyone confirm that this fails to build which a
> buggy gcc:
> 
> 
> void __attribute__((weak)) func(void)
> {
>     /* no code */
> }
> 
> int main()
> {
>     func();
>     return 0;
> }

Of course it doesn't fail to build.  With buggy gcc it will be optimized
to
void __attribute__((weak)) func (void)
{
}

int main ()
{
  return 0;
}

(similarly how all recent gccs optimize this without the weak attribute)
while non-buggy gcc keeps the func call.
So, you either need to grep the assembly (that's what e.g. the GCC testcase
does), or you can e.g. use a runtime testcase:
extern void abort (void);
void __attribute__((weak)) func (void) { }
int main () { func (); abort (); }
in one compilation unit and
extern void exit (int);
void func (void) { exit (0); }
in another one.  I doubt a runtime testcase is acceptable though for the
kernel, as the cross compiler used to build the kernel might not be able to
create userland executables (missing C library, etc.).

	Jakub
