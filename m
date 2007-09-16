Return-Path: <linux-kernel-owner+w=401wt.eu-S1753567AbXIPQnE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567AbXIPQnE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 12:43:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752794AbXIPQmy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 12:42:54 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:3287 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752572AbXIPQmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 12:42:54 -0400
Date: Sun, 16 Sep 2007 18:43:26 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Shlomi Fish <shlomif@freehackers.org>
cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2.6.23-rc4] qconf ("make xconfig") Search Dialog Enhancement
 (rev8)
In-Reply-To: <200709132252.20719.shlomif@freehackers.org>
Message-ID: <Pine.LNX.4.64.0709160043430.1817@scrub.home>
References: <200709132252.20719.shlomif@freehackers.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 13 Sep 2007, Shlomi Fish wrote:

> This patch adds an option to use either substring match, regular expression 
> match, or keywords search in the "make xconfig" Edit->Find dialog.
> 
> It also allows searching on the "help" field of the menus as well as 
> the "name" of the symbol.
> 
> This change involved adding the sym_generic_search function to the LKC, and 
> implementing sym_re_search using it.

I like the direction, but first of all please fix the coding style.
I would also prefer to move more of the search functionality into the
generic code, so it can be used by other front ends as well, otherwise a
lot of this had to be duplicated.
I think a filter function makes it maybe a bit to flexible, if a front
end wants to do some weird filtering, it can still access the symbol
data base directly. So what I have in mind is something like this:

struct symbol **sym_generic_search(const char *pattern, unsigned int flags);

This means the back end provides a basic search facility for the most
common search operations. The flags would specify what to search (e.g.
symbol name, help text, prompts) and how to do it.


> @@ -1199,6 +1199,23 @@
>  	layout2->addWidget(searchButton);
>  	layout1->addLayout(layout2);
>  
> +	// Initialize the "Search Type" button group.
> +	searchType = new QVButtonGroup("Search Type", this, "searchType");
> +
> +	substringSearch = new QRadioButton(
> +		"Substring Match", searchType, "Substring Match"
> +		);
> +
> +	keywordsSearch = new QRadioButton("Keywords", searchType, "Keywords");
> +
> +	regexSearch = new QRadioButton(
> +		"Regular Expression", searchType, "Regular Expression"
> +		);
> +
> +	substringSearch->setChecked(TRUE);
> +	layout1->addWidget(searchType);
> +
> +	// Initialize the ConfigView and ConfigInfoView
>  	split = new QSplitter(this);
>  	split->setOrientation(QSplitter::Vertical);
>  	list = new ConfigView(split, name);
> @@ -1245,6 +1262,20 @@
>  	}
>  }
>  
> +SEARCH_TYPE ConfigSearchWindow::getSearchType()
> +{
> +	return	substringSearch->isChecked() ? SUBSTRING :
> +		regexSearch->isChecked() ? REGEX :
> +		KEYWORDS;
> +}
>

If you use QButtonGroup::insert() you can assign id's to the indivual
buttons and then use selectedId to make this part simpler.

bye, Roman
