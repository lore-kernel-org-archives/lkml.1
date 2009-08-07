Return-Path: <linux-kernel-owner+w=401wt.eu-S933044AbZHGTLO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044AbZHGTLO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 15:11:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932928AbZHGTLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 15:11:13 -0400
Received: from sparc.brc.ubc.ca ([137.82.2.12]:55550 "EHLO sparc.brc.ubc.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932924AbZHGTLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 15:11:13 -0400
Date: Fri, 7 Aug 2009 12:32:34 -0700 (PDT)
From: "Li, Ming Chun" <macli@brc.ubc.ca>
To: Mel Gorman <mel@csn.ul.ie>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] tracing, page-allocator: Add a postprocessing script
 for page-allocator-related ftrace events
In-Reply-To: <alpine.DEB.1.00.0908071154120.14649@mail.selltech.ca>
Message-ID: <alpine.DEB.1.00.0908071228310.14726@mail.selltech.ca>
References: <1249666815-28784-1-git-send-email-mel@csn.ul.ie> <1249666815-28784-5-git-send-email-mel@csn.ul.ie> <alpine.DEB.1.00.0908071154120.14649@mail.selltech.ca>
User-Agent: Alpine 1.00 (DEB 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Aug 2009, Li, Ming Chun wrote:

> On Fri, 7 Aug 2009, Mel Gorman wrote:
> 
> > +sub generate_traceevent_regex {
> > +	my $event = shift;
> > +	my $default = shift;
> > +	my @fields = @_;
> > +	my $regex;
> 
> You are using shift to retrieve parameters below, @fields is not used 
> anywhere.
> 
> > +
> > +	# Read the event format or use the default
> > +	if (!open (FORMAT, "/sys/kernel/debug/tracing/events/$event/format")) {
> > +		$regex = $default;
> > +	} else {
> > +		my $line;
> > +		while (!eof(FORMAT)) {
> > +			$line = <FORMAT>;
> > +			if ($line =~ /^print fmt:\s"(.*)",.*/) {
> > +				$regex = $1;
> > +				$regex =~ s/%p/\([0-9a-f]*\)/g;
> > +				$regex =~ s/%d/\([-0-9]*\)/g;
> > +				$regex =~ s/%lu/\([0-9]*\)/g;
> > +			}
> > +		}
> > +	}
> > +
> > +	# Verify fields are in the right order
> > +	my $tuple;
> > +	foreach $tuple (split /\s/, $regex) {
> > +		my ($key, $value) = split(/=/, $tuple);
> > +		my $expected = shift;
> > +		if ($key ne $expected) {
> > +			print("WARNING: Format not as expected '$key' != '$expected'");
> > +			$regex =~ s/$key=\((.*)\)/$key=$1/;
> > +		}
> > +	}
> > +	if (defined $_) {
> > +		die("Fewer fields than expected in format");
> > +	}
> > +
> 
> How about:
> 	if (defined shift) {
> 		die("Fewer fields than expected in format");
> 	}
> ? 
> 
> I don't know, just ask if it is clear.

Ah, I think it should be:
	if (@_) {
		die("Fewer fields than expected in format");
	}

? Sorry for the noise :)

> 
> > +	return $regex;
> > +}
> 
> 

Vincent Li
Biomedical Research Center
University of British Columbia
