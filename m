Return-Path: <linux-kernel-owner+w=401wt.eu-S1754961AbXITWPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754961AbXITWPA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 18:15:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752312AbXITWOx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 18:14:53 -0400
Received: from DSL022.labridge.com ([206.117.136.22]:3182 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbXITWOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 18:14:52 -0400
Subject: Re: [Announce] Linux-tiny project revival
From: Joe Perches <joe@perches.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: Rob Landley <rob@landley.net>, linux-tiny@selenic.com,
       linux kernel <linux-kernel@vger.kernel.org>,
       CE Linux Developers List <celinux-dev@tree.celinuxforum.org>,
       Michael Opdenacker <michael@free-electrons.com>
In-Reply-To: <46F2ED1E.3090407@am.sony.com>
References: <46F1645D.9050406@am.sony.com>
	 <200709201538.43093.rob@landley.net>  <46F2ED1E.3090407@am.sony.com>
Content-Type: text/plain
Date: Thu, 20 Sep 2007 15:14:25 -0700
Message-Id: <1190326465.26101.171.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2-2.1mdv2007.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-09-20 at 14:58 -0700, Tim Bird wrote:
> Given that there are about 60,000 printks in the kernel (and that's
> not counting wrappers like dprintk() and other locally-defined
> functions and macros) it would be a huge task to examine the code
> and differentiate strings that really start a new log message
> (and thus should have an attached log level) and strings
> that don't.

I've converted most all of that treewide.

printk(KERN_<level> to pr_<level>(

It's pretty automated.

$ cat pr_alert.sh
#!/bin/sh
egrep -r -w --include=*.[ch] -l "printk[[:space:]]*\([[:space:]]*KERN_ALERT" * | \
 xargs perl ../cvt_pr.pl KERN_ALERT pr_alert

$ cat cvt_pr.pl
if ($#ARGV < 3) {
    print "usage: KERN_<level> pr_<level> files...\n";
    exit;
}

for ($i=2; $i<$#ARGV; $i++) {
    PrintkSearchReplace($ARGV[$i], $ARGV[0], $ARGV[1]);
}

sub PrintkSearchReplace{
    my($file, $search, $replace) = @_;

    my $content = "";
    local( $/ );
    open( my $fh, $file ) or die "File not found '$file'\n";
    $content = <$fh>;
    close(my $fh);
    my $orig = $content;

    $content =~ s/\bprintk[[:space:]]*\([[:space:]]*${search}[[:space:]]*([^\"]*)\"([^\\]*)\\n\"/${replace}\(\1 \"\2\"/mgs;
    $content =~ s/\b${replace}\( /${replace}\(/mgs;
    
    if ($orig ne $content)
    {
        open(my $fh, ">${file}") or die "Could not open '$file'\n";
        print $fh $content;
        close(my $fh);
    } 
}


